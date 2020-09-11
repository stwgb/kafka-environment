# Avro

## Primitive Types

- null: no value
- boolean: a binary value
- int: 32-bit signed integer
- long: 64-bit signed integer
- float: single precision (32-bit) IEEE 754 floating-point number
- double: double precision (64-bit) IEEE 754 floating-point number
- bytes: sequence 8-bit unsigned bytes
- string: unicode character sequence 

## Avro Schema Definition

- Avro Record Schemas (.avsc files) are defined using JSON
- Have common fields:
    - Name
    - Namespace
    - Doc (optional)
    - Alias
    - Fields Array of [Name, Doc, Type, Default(optional)]

### Example of an Avro Schema Definition with primitive Types

An example of an Avro Schema Definition for a customer
```json
{
  "type": "record",
  "namespace": "com.example",
  "name": "Customer",
  "doc": "schema for the customer",
  "fields": [
    { "name": "firstName", "type": "string", "doc": "first name of the customer" },
    { "name": "lastName", "type": "string", "doc": "last name of the customer" },
    { "name": "age", "type": "int", "doc": "age of the customer" },
    { "name": "height", "type": "float", "doc": "height in cms of the customer" },
    { "name": "weight", "type": "float", "doc": "weight in kgs of the customer" },
    { "name": "autoMailTurnedOn", "type": "boolean", "default": true, "doc": "automated mailing" }
  ]  
}
```

## Complex Types

- Enums
- Arrays
- Maps
- Unions
- Calling other schemas as types

### Enums

Enums are fields which can be enumerated eg. customer status can be bronze, silver, gold. This leads to the following 
entry in the schema:

```json
{ "name": "CustomerStatus", "type": "enum", "symbols": ["bronze", "silver", "gold"] }
```

**Note**: Once the values on the enum is set you can't change them if you want to maintain compatibility. 
So be sure if you use enums.

### Arrays

Arrays represent a list of undefined size of items which share the same schema eg. a customer has multiple emails 
`[john.doe@gmail.com, john11@web.de]`. This leads to the following entry in the schema:

```json
{ "type": "array", "items": "string" }
```

**Note**: The items can be everything also a schema.

### Maps

Maps enable to define a list of key-value-pairs, where the keys are string eg. secret questions. 
This leads to the following entry in the schema:

```json
{ "type": "map", "values": "string" }
```

**Note**: The values can be everything also a schema.

### Unions

Unions allowing field values to take different types eg. `["string", "boolean", "int"]` If you use default values, 
the default must be of the type of the first item in the union. In this case is a string. 
The most common use case is to define an optional value. This leads to the following entry in the schema:

```json
{ "name": "middleName", "type": ["null", "string"], "default": null }
```

**Note**: It is null without quotes and not "null"

### Example adding complex types

```json
[
  {
      "type": "record",
      "namespace": "com.example",
      "name": "CustomerAddress",
      "fields": [
        { "name": "address", "type": "string" },
        { "name": "city", "type": "string" },
        { "name": "postcode", "type": ["string", "int"] },
        { "name": "type", "type": "enum", "symbols": ["PO BOX", "RESIDENTIAL", "ENTERPRISE"] }
      ]
  },
  {
     "type": "record",
     "namespace": "com.example",
     "name": "Customer",
     "fields": [
       { "name": "first_name", "type": "string" },
       { "name": "middle_name", "type": ["null", "string"], "default": null },       
       { "name": "last_name", "type": "string" },
       { "name": "age", "type": "int" },
       { "name": "height", "type": "float" },
       { "name": "weight", "type": "float" },
       { "name": "automated_email", "type": "boolean", "default": true },
       { "name": "customer_emails", "type": "array", "items": "string", "default": []},
       { "name": "customer_address", "type": "com.example.CustomerAddress" }
     ]
}]
```

## Logical Types

Logical Types give more meaning to the primitive types:

- decimals (bytes) are used for money
- date (int) - number of days since unix epoch
- time-millis (long) - number of milliseconds after midnight 00:00:00.000
- timestamp-millis (long) - number of milliseconds since unix epoch (1.January 1970 00:00:00.000 UTC)

### Using logical types

You can use logical types by adding the logical-type entry eg.
`{"name": "singedUpTS", "type": "long", "logicalType": "timestamp-millis"}`


## Generic Record

A generic record is used to create an avro object from a schema. The Schema can be a file or a string. 
Runtime errors are possible if field doesn't exist (java)

## Specific Record

A specific record is an avro object created by using code generation from an avro schema -> No runtime errors (java)

## Avro Reflection

Avro Reflection is used to build avro schemas from classes.

## Schema Evolution

Avro enables to evolve the schema over time -> allows adapting changes from the business. Eg. 
Now the first and last name of a customer are needed and in a later version the phone number should be added. 
The programmes should no break. Data is a contract between producers and consumers. There are four kinds of schema evolution:  

1. **Backwards**: A backwards compatible change is when a new schema can be used to read old data. 
With V2 schema you can read V1 data. Achieved by adding defaults to the new schema.
2. **Forwards**: A forward compatible change is when an old schema can be used to read new data. 
With V1 schema you can read V2 data. Avro will ignore new fields. Deleting fields without defaults will break forward compatibility.
3. **Full**: Forwards and Backwards -> should be targeted. The rules are: adding only fields with defaults and only remove 
fields with defaults.
4. **Breaking**: none of 1-3 -> should never be done. Eg add/remove elements of enums, changing the type of a field (string -> int), 
rename a required field (without default)

### Advices for Schema Evolution

1. Make your primary key required -> no defaults
2. Give defaults to all fields which can be removed in future
3. Be careful when using enums, they can't evolve
4. Do not rename fields, instead add aliases
5. When evolving schema always add default values 
6. When evolving schema never delete required fields