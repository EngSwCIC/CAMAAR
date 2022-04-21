create table participantes (
    id int auto_increment not null primary key,
    nome varchar(255) not null,
    matricula varchar(11) not null unique,
    usuario varchar(11) not null,
    email varchar(255) not null,
    formacao varchar(255) not null,
    ocupacao varchar(255) not null
);