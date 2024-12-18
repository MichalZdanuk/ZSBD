-- DaysSinceLastMedicalProcedure
CREATE OR REPLACE FUNCTION shelter.dayssincelastmedicalprocedure(
    paramdogid UUID,
    paramprocedurename VARCHAR(1000) DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    dayssincelastprocedure INTEGER;
BEGIN
    SELECT DATE_PART('day', CURRENT_DATE - MAX(mcr.date)) INTO dayssincelastprocedure
    FROM shelter.medicalcardrecords AS mcr
    JOIN shelter.medicalcards AS mc ON mc.id = mcr.medicalcardid
    WHERE mc.dogid = paramdogid
      AND (paramprocedurename IS NULL OR mcr.description ILIKE '%' || paramprocedurename || '%');
    
    RETURN COALESCE(dayssincelastprocedure, -1);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- DaysSinceLastAdoptionRequest
CREATE OR REPLACE FUNCTION shelter.dayssincelastadoptionrequest(
    paramdogid UUID
)
RETURNS INTEGER AS $$
DECLARE
    dayssincelastrequest INTEGER;
BEGIN
    SELECT DATE_PART('day', CURRENT_DATE - MAX(ar.lastupdatedate)) INTO dayssincelastrequest
    FROM shelter.adoptionrecords AS ar
    JOIN shelter.dogs AS d ON d.id = ar.dogid
    WHERE ar.dogid = paramdogid AND d.dogstatusid = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c';
    
    RETURN COALESCE(dayssincelastrequest, -1);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
