CREATE USER shelterclient WITH PASSWORD '';
ALTER ROLE shelterclient WITH LOGIN;
GRANT CONNECT ON DATABASE "ShelterDB" TO shelterclient;
ALTER ROLE shelterclient SET search_path TO shelter;
GRANT SELECT ON "shelter".clientadoptionhistoryview TO shelterclient;
GRANT USAGE ON SCHEMA shelter TO shelterclient;
GRANT SELECT ON "shelter".clientavailabledogsview TO shelterclient;
GRANT EXECUTE ON PROCEDURE "shelter".submitadoptionrequest(uuid, uuid) TO shelterclient;
GRANT EXECUTE ON PROCEDURE "shelter".submitfamiliarizationvisitrequest(uuid, uuid) TO shelterclient;


CREATE USER shelteremployee WITH PASSWORD '';
ALTER ROLE shelteremployee WITH LOGIN;
GRANT CONNECT ON DATABASE "ShelterDB" TO shelteremployee;
ALTER ROLE shelteremployee SET search_path TO shelter;
GRANT EXECUTE ON PROCEDURE shelter.addclient(character varying, character varying, character varying, character varying, date) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE shelter.adddog(character varying, character varying, date, uuid, integer, character varying) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE shelter.addshelter(character varying, uuid) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE shelter.submitadoptionrequest(uuid, uuid) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE shelter.updateadoptionrecordstatus(uuid, uuid) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE "shelter".submitfamiliarizationvisitrequest(uuid, uuid) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE shelter.updatefamiliarizationvisit(uuid, uuid, timestamp with time zone, timestamp with time zone, uuid, text) TO shelteremployee;
GRANT EXECUTE ON PROCEDURE shelter.updatedogstatus(uuid, uuid) TO shelteremployee;
GRANT EXECUTE ON FUNCTION shelter.dayssincelastmedicalprocedure(UUID, VARCHAR) TO shelteremployee;
GRANT EXECUTE ON FUNCTION shelter.dayssincelastadoptionrequest(UUID) TO shelteremployee;
