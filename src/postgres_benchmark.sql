DO $$
DECLARE
  v_ts TIMESTAMP;
  v_repeat CONSTANT INT := 10000;
  rec RECORD;
BEGIN

  /* Repeat the whole benchmark several times to avoid warmup penalty */
  FOR i IN 1..5 LOOP
    v_ts := clock_timestamp();
    FOR i IN 1..v_repeat LOOP
      FOR rec IN (
        select * from tenktup1
        where unique2 between 0 and 99
/*
        SELECT first_name, last_name, count(fa.actor_id) AS c
        FROM actor a
        LEFT JOIN film_actor fa
        ON a.actor_id = fa.actor_id
        WHERE last_name LIKE 'A%'
        GROUP BY a.actor_id, first_name, last_name
        ORDER BY c DESC
*/
      ) LOOP
        NULL;
      END LOOP;
    END LOOP;
    RAISE INFO 'Run %, Statement 1: %', i, (clock_timestamp() - v_ts); 
    v_ts := clock_timestamp();
    FOR i IN 1..v_repeat LOOP
      FOR rec IN (
        select * from tenktup1
        where unique2 between 792 and 1791
/*
        SELECT first_name, last_name, (
          SELECT count(*)
          FROM film_actor fa
          WHERE a.actor_id =
          fa.actor_id
        ) AS c
        FROM actor a
        WHERE last_name LIKE 'A%'
        ORDER BY c DESC
*/
      ) LOOP
        NULL;
      END LOOP;
    END LOOP;
    RAISE INFO 'Run %, Statement 2: %', i, (clock_timestamp() - v_ts); 
  END LOOP;
END$$;
