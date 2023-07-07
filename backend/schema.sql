drop table if exists coloc;
create table coloc
(
    jobid     varchar(255) not null,
    threshold varchar(255) not null
);

drop table if exists fastenloc;
create table fastenloc
(
    jobid  varchar(255) not null,
    prefix varchar(255) not null
);

drop table if exists job;
create table job
(
    jobid       varchar(255) not null
        primary key,
    status      varchar(255) not null,
    result_path varchar(255) not null,
    type        varchar(255) not null,
    create_time varchar(255) not null,
    finish_time varchar(255) null,
    dir_path    varchar(255) not null
);

drop table if exists resultfile;
create table resultfile
(
    fileid   varchar(255) not null
        primary key,
    jobid    varchar(255) not null,
    filename varchar(255) not null,
    path     varchar(255) not null
);

drop table if exists userfile;
create table userfile
(
    ID        varchar(255) not null
        primary key,
    File_path varchar(255) not null,
    File_name varchar(255) not null
);

