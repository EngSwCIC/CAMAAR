create table materias (
    id int auto_increment not null primary key,
    codigo varchar(255) unique not null,
    nome varchar(255) unique not null
);