# complex-event-processor
Match an event stream against a predefined set of access patterns to identify relevant events.


```sh
curl -X POST localhost:8080/expression \
    -H 'Content-Type: application/json ' \
    -d '{"id":"query-1","tenant_id":"1","predicates":[{"id":"A","event_type":"EMAIL_OPENED","conditions":[{"field":"email","operator":"eq","value":"a"},{"field":"provider","operator":"not_eq","value":"gmail"}],"immutable":true},{"id":"B","event_type":"EMAIL_CLICKED","conditions":[{"field":"link","operator":"eq","value":"http://google.com"}],"immutable":true}],"logical_expression":{"connector":"and","predicates":[{"predicate":{"id":"A","event_type":"EMAIL_OPENED","conditions":[{"field":"email","operator":"eq","value":"a"},{"field":"provider","operator":"not_eq","value":"gmail"}],"immutable":true}},{"predicate":{"id":"B","event_type":"EMAIL_CLICKED","conditions":[{"field":"link","operator":"eq","value":"http://google.com"}],"immutable":true}}]}}'

curl -X POST localhost:8080/event \
    -H 'Content-Type: application/json ' \
    -d '{"id":"1","tenant_id":"1","type":"EMAIL_OPENED","payload":{"email":"a","provider":"gmail"}}'

curl -X POST localhost:8080/event \
    -H 'Content-Type: application/json ' \
    -d '{"id":"2","tenant_id":"1","type":"EMAIL_OPENED","payload":{"email":"b"}}'

curl -X POST localhost:8080/event \
    -H 'Content-Type: application/json ' \
    -d '{"id":"3","tenant_id":"1","type":"EMAIL_CLICKED","payload":{"link":"http://google.com"}}'
```


