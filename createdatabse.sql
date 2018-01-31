create database ntko DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

GRANT ALL ON ntko.* TO root@localhost;

USE ntko;

create table ntkoofficefile (id int not null primary key auto_increment,
filename varchar(256),
filesize int,
otherdata varchar(128),
filetype varchar(64),
filenamedisk varchar(256),
attachfilenamedisk varchar(256),
attachfiledescribe varchar(256)
);

create table ntkohtmlfile( id int not null primary key auto_increment,
filename varchar(256),
filepath varchar(256),
filesize int);

create table ntkopdffile(id int not null primary key auto_increment,
pdffilename varchar(256),
pdffilepath varchar(256),
filesize int);