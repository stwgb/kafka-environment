# Kafka-Connect

## Motivation - Why Kafka-Connect

Kafka-Connect enables to connect source- and sink-systems to your kafka-cluster without touching these systems. 
In example storing data in a database. You do not have to write a consumer to get the data out of kafka and writes it to the database. 
Kafka-connect gives you the possibility to launch a connector which uses kafka-connect-apis to get the data out of kafka and stores it in the database. 
If you have to write a connector you can use the kafka-connect-apis to interact with kafka, and 
you implement the code you need to interact with the system. To connect more systems you can start more 
connectors, and the data-pipeline is up. In addition to that source- and sink-system are often the same and there are 
lots of programmers who made up there mind about fault-tolerance, exactly-once, distribution, ordering, etc and implemented 
a connector for those systems. You can use these connectors and launch them with your configurations, because of the 
kafka-connect-framework those connectors are highly configurable. 

## Kafka-Connect Concepts

### Architecture 

## todo

### Connectors

Each kafka-connect-cluster has at least one single connector. A connector is re-usable and differs in the configuration. 
Connectors are responsible for:

- The amount of tasks for the connector.
- Splitting work between tasks.
- Getting the configuration from the worker and pass it to the task.

#### Source Connectors

Source-connectors get the data out of a source-system and pushes the data into a kafka-cluster.

#### Sink Connectors

Sink-connectors fetch the data from a kafka-cluster and publish the data into a sink-system.

#### Task

A task is a connector with a configuration. Tasks are responsible to get the data in and out from kafka. 
The source connectors tasks allow storing offsets, and the sink connectors tasks allowing the handling of back-pressure, 
retrying and storing offsets for exactly-once delivery. The configuration gets loaded in the start-up of the task. 
A configuration may create multiple tasks.

#### Workers

Workers are kafka-connect-servers which execute the connectors and tasks. Workers also take http-requests 
(eg. defining connectors) and handle them. They also store the connector configuration, launch the connectors and 
theirs tasks. If a workers goes down the other worker will recognize it and reassign the connector with their tasks. 
When a worker joins the cluster the task also gets reassigned to load balance the work. Another job of the worker is to 
commit the offsets (for source and sink).

#### Conclusion

- Connectors + Tasks -> moving data
- workers -> REST API, configuration management, reliability, high availability, scaling, and load balancing

## Standalone Mode

- Single process running connectors and tasks.
- Configuration is bundled with process.
- Easy to get started -> useful in development and testing.
- Not fault-tolerant.
- Hard to monitor.
- Not scalable (vertical).

## Distributed Mode

- Multiple worker running connectors and tasks.
- Configuration of task with REST-APIs.
- Easy scalable.
- Fault tolerant.
- For production.

## Writing a Custom Kafka-Connector

1. Setup project and add:
    - A task to build fat jar
    - The [kafka-connect-api](https://mvnrepository.com/artifact/org.apache.kafka/connect-api/2.5.0) as dependency
    - create config dir

2. A source connector needs to implement the following classes:
    - SourceConnector
    - SourceTask
    - AbstractConfig

3. Follow the steps:
    1. create in config dir a `.properties` file and name link the connector
    2. Define your configuration properties
    3. Create Connector which load the config and starts tasks
    4. Create a schema for the data
    5. Source partition and source offsets
    6. Create the task

### 2 Define configuration

```java
package org.stwgb;

import org.apache.kafka.common.config.AbstractConfig;
import org.apache.kafka.common.config.ConfigDef;
import org.stwgb.validators.BatchSizeValidator;
import org.stwgb.validators.TimestampValidator;

import java.time.ZonedDateTime;
import java.util.Map;

public class GithubSourceConnectorConfig extends AbstractConfig {

    public static final String TOPIC_CONFIG = "topic";
    private static final String TOPIC_DOC = "Topic to write to";


    public static final String SINCE_CONFIG = "since.timestamp";
    private static final String SINCE_DOC =
            "Only issues updated at or after this time are returned.\n"
                    + "This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.\n"
                    + "Defaults to a year from first launch.";

    public static final String BATCH_SIZE_CONFIG = "batch.size";
    private static final String BATCH_SIZE_DOC = "Number of data points to retrieve at a time. Defaults to 100 (max value)";


    public static final String AUTH_PASSWORD_CONFIG = "auth.password";
    private static final String AUTH_PASSWORD_DOC = "Optional Password to authenticate calls";

    public GithubSourceConnectorConfig(ConfigDef definition, Map<?, ?> originals) {
        super(definition, originals);
    }


    public GithubSourceConnectorConfig(Map<String, String> parsedConfig) {
        this(conf(), parsedConfig);
    }

    public static ConfigDef conf() {
        return new ConfigDef()
                .define(TOPIC_CONFIG, ConfigDef.Type.STRING, ConfigDef.Importance.HIGH, TOPIC_DOC)
                .define(BATCH_SIZE_CONFIG, ConfigDef.Type.INT, 100, new BatchSizeValidator(), ConfigDef.Importance.LOW, BATCH_SIZE_DOC)
                .define(SINCE_CONFIG, ConfigDef.Type.STRING, ZonedDateTime.now().minusYears(1).toInstant().toString(),
                        new TimestampValidator(), ConfigDef.Importance.HIGH, SINCE_DOC)
                .define(AUTH_PASSWORD_CONFIG, ConfigDef.Type.PASSWORD, "", ConfigDef.Importance.HIGH, AUTH_PASSWORD_DOC);
    }
}

```

**Note:** By using default the configuration gets optional.   
**Note:** You can validate the configuration by implementing the config validator.

```java
package org.stwgb.validators;

import org.apache.kafka.common.config.ConfigDef.Validator;
import org.apache.kafka.common.config.ConfigException;

public class BatchSizeValidator implements Validator {
    @Override
    public void ensureValid(String name, Object value) {
        Integer batchSize = (Integer) value;
        if (!(1 <= batchSize && batchSize <= 100)){
            throw new ConfigException(name, value, "Batch Size must be a positive integer that's less or equal to 100");
        }
    }
}
```

### 3 Create Connector

You have to implement:

-> Create your connector class and extend it by the connector `public class GithubSourceConnector extends Connector`

Then add a Logger and the connectorConfig as private properties. 

- version ->  the version of the connector -> Create a class eg Version util which returns the version and call it in the version method
- start -> starting the connector -> init the configuration of the connector, by calling the constructor of the Config class and assign it to the config property. Open connections if needed eg databases
- taskClass -> return the class of the connector -> return the class which implements the task.
- taskConfigs -> list of configs for the task -> return an array list with the configuration of your task.
- stop -> stopping the connector -> close connections if needed eg databases
- configDef -> returning the config definition 

```java
package org.stwgb;

import org.apache.kafka.common.config.ConfigDef;
import org.apache.kafka.connect.connector.Connector;
import org.apache.kafka.connect.connector.Task;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class GithubSourceConnector extends Connector {

    private static Logger logger = LoggerFactory.getLogger(GithubSourceConnector.class);
    private GithubSourceConnectorConfig config;

    @Override
    public void start(Map<String, String> props) {
        this.config = new GithubSourceConnectorConfig(props);
    }

    @Override
    public Class<? extends Task> taskClass() {
        return GithubSourceTask.class;
    }

    @Override
    public List<Map<String, String>> taskConfigs(int maxTasks) {
        // Define the individual task configurations that will be executed.
        // Wen using multiple tasks extend this method if needed
        ArrayList<Map<String, String>> configs = new ArrayList<>(1);
        configs.add(config.originalsStrings());
        return configs;
    }

    @Override
    public void stop() {
        // no connections to close -> nothing to to do here
    }

    @Override
    public ConfigDef config() {
        return GithubSourceConnectorConfig.conf();
    }

    @Override
    public String version() {
        return VersionUtil.getVersion();
    }
}
```
### Create a Schema for the data

- Use constants for the files name
- Build a schema for nested data
- Build the schema with the constants and reference the schema for nested data

Next listing is incomplete to save space

```java
package org.stwgb;

import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.data.SchemaBuilder;
import org.apache.kafka.connect.data.Timestamp;

public class GithubSchema {
    public static final String NEXT_PAGE_FIELD = "next_page";

    // Issue fields
    public static final String OWNER_FIELD = "owner";
    public static final String REPOSITORY_FIELD = "repository";


    // User fields
    public static final String USER_FIELD = "user";
    public static final String USER_URL_FIELD = "url";

    // PR fields
    public static final String PR_FIELD = "pull_request";
    public static final String PR_URL_FIELD = "url";

    // Schema names
    public static final String SCHEMA_KEY = "org.stwgb.kafka.connect.github.IssueKey";
    public static final String SCHEMA_VALUE_ISSUE = "org.stwgb.kafka.connect.github.IssueValue";
    public static final String SCHEMA_VALUE_USER = "org.stwgb.kafka.connect.github.UserValue";
    public static final String SCHEMA_VALUE_PR = "org.stwgb.kafka.connect.github.PrValue";

    // Key Schema
    public static final Schema KEY_SCHEMA = SchemaBuilder.struct().name(SCHEMA_KEY)
            .version(1)
            .field(OWNER_FIELD, Schema.STRING_SCHEMA)
            .field(NUMBER_FIELD, Schema.INT32_SCHEMA)
            .build();

    // Value Schema
    public static final Schema USER_SCHEMA = SchemaBuilder.struct().name(SCHEMA_VALUE_USER)
            .version(1)
            .field(USER_URL_FIELD, Schema.STRING_SCHEMA)
            .field(USER_ID_FIELD, Schema.INT32_SCHEMA)
            .build();

    // optional schema
    public static final Schema PR_SCHEMA = SchemaBuilder.struct().name(SCHEMA_VALUE_PR)
            .version(1)
            .field(PR_URL_FIELD, Schema.STRING_SCHEMA)
            .optional()
            .build();

    public static final Schema VALUE_SCHEMA = SchemaBuilder.struct().name(SCHEMA_VALUE_ISSUE)
            .version(2)
            .field(URL_FIELD, Schema.STRING_SCHEMA)
            .field(CREATED_AT_FIELD, Timestamp.SCHEMA)
            .field(NUMBER_FIELD, Schema.INT32_SCHEMA)
            .field(USER_FIELD, USER_SCHEMA) // mandatory
            .field(PR_FIELD, PR_SCHEMA)     // optional
            .build();
}
```
### 5 Source Partitions and Source Offsets

Connectors are stateless, to save the state you need to track partitions and offsets 
(these partitions have nothing to do with kafka, they are referenced to the source of the data)

Source partitions enables kafka connect to store the data source (where the data came from). 


Source offsets allow to track the position the connector has stopped reading. 

These setting must be setup in the task and called in the SourceRecord 

```java

    // Github repo as source
    private Map<String, String> sourcePartition() {
        Map<String, String> map = new HashMap<>();
        map.put(OWNER_FIELD, config.getOwnerConfig());
        map.put(REPOSITORY_FIELD, config.getRepoConfig());
        return map;
    }
    // last fetch of data
    private Map<String, String> sourceOffset(Instant updatedAt) {
        Map<String, String> map = new HashMap<>();
        map.put(UPDATED_AT_FIELD, DateUtils.MaxInstant(updatedAt, nextQuerySince).toString());
        map.put(NEXT_PAGE_FIELD, nextPageToVisit.toString());
        return map;
    }
```
### 6 Creating the Task

Last step is to implement the task, which does the actual work.
The interface comes with:

- version ->  the version of the task -> should be same as the version of the connector 
- start -> starting the task -> init the configuration of the task
- poll -> called continuously  -> polls data from source and put into kafka
- taskConfigs -> list of configs for the task -> return an array list with the configuration of your task.
- stop -> stopping the connector -> close connections if needed eg databases
