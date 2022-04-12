# Data Shape Log

## Types

hexId = uuid.v4
date = unix epoch date

## Exercise

Stored in a file, with the name "id.json"

```json
{
    "id": "hexId",
    "title": "string",
    "type": "int = [1=set, 2=superSet]",
    "isNested": "bool",
    "modules": [MODULE],
    "sModules": [EXERCISE],
    "created": "date",
    "updated": "date",
    "logs": [LOG],
}
```

Show sModules when type==2, modules when type==1

sModules are a list of exercises, but cannot have type==2 otherwise it could cause to recursive issues

For logs, a "snapshot" of data is taken of the entire exercise shape, letting the user edit any reps or weights before posting. These cannot be edited after the fact, so the date is when the snapshot was taken. Sorted in ascending order, so the latest is first in the list.

When the exercise is edited, the new shape will rewrite the id.json file, and will edit the index file to make sure the titles match up.

## Module

```json
{
    "id": "hexId",
    "reps": "int?",
    "weight": "int?",
    "time": "int?",
    "percent": "string?",
    "weightType": "enum = [lbs, kg]?",
    "timeType": "enum = [sec, min]?",
    "created": "date",
    "updated": "date",
}
```

## Log

```json
{
    "id": "hexId",
    "date": "date",
    "snapshot": EXERCISE,
}
```

When a log is created, an entry is created in the log file with the date and the id of the exercise. If the date already exists, then the ids are appended to the data entry.


## Database Design

### Index File

```json
[
    {
        "title": "string",
        "filename": "id.json",
    }
]
```

The index file will be read on startup, and held in memory for the lifetime of the app. When the user clicks on an exercise, the cooresponding filename will be read during the page transition for the detail page. The file will be voided from memory after the user exits the page.

### Log Index File

```json
[
    {
        "date": "date",
        "data": [
            {
                "exerciseId": "hexId",
                "logId": "hexId",
            }
        ],
    }
]
```

This log file will be stored in memory when the user is viewing the calender view to see their progress. The date field will allow for a dot to be displayed on the calendar. When the day is clicked, the exercise file will be read with exerciseId, and the log is found with the logId field to show the log. These logs are immutible, so no editing needs to be accounted for. Though, they can be deleted.