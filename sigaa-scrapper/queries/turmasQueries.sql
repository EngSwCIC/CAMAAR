create table turmas (
    id int auto_increment not null primary key,
    codigo_materia int not null,
    codigo varchar(255) unique,
    semestre varchar(255),
    horario varchar(255),
    foreign key (codigo_materia) references materias(id)
);