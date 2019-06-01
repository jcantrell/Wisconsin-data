%CS487
%Project Part 2
%Jordan Cantrell

1.  # System Choice
    In this benchmark, we investigate a single DBMS system, MySql. This
    system was chosen for investigation due to its ease of use and free
    pricetag, and to investigate the feasability of running a database
    on consumer hardware, at home.

2.  # System Research
    5 (mysql) parameters from Memory or Query Planner options, and
    describe them.

    1. innodb_buffer_pool_size (default value is 128M)
        This variable controls the size (in bytes) of the buffer pool, which
        is where table and index data are cached.
    2. block_nested_loop (default is on)
        This flag controls the use of the Block-Nested Loop algorithm to
        join relations.
    3. semijoin (default on)
        This flag controls whether semijoins are used during a query.
    4. index_merge (default on)
       condition_fanout_filter (default on)
        This flag allows the optimizer to use information about conditions
        on the rows being selected to estimate the number of row combinations
        during a join, and choose an appropriate execution plan.
    5. skip_scan (default on)
        This flag toggles the use of the Skip Scan method to more
        more efficiently select queries by scanning through the distinct
        values of the index, and then doing a subrange scan on the other
        attribute.

3.  # Performance experiment Design
Experiment 1: Different relation sizes
Experiment 2: enable_mergejoin (Postgres)
Experiment 3: shared_buffers (postgres)
Experiment 4: enable_indexscan (postgres)

