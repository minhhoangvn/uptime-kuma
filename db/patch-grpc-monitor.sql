-- You should not modify if this have pushed to Github, unless it does serious wrong with the db.
BEGIN TRANSACTION;

ALTER TABLE monitor
    ADD grpc_protobuf TEXT default null;

ALTER TABLE monitor
    ADD grpc_body TEXT default null;

ALTER TABLE monitor
    ADD grpc_metadata TEXT default null;

COMMIT;
