create table tb_turmas_participantes (
    id int auto_increment not null primary key,
    idParticipante int not null,
    idTurma int not null,
    foreign key (idParticipante) references participantes(id),
    foreign key (idTurma) references turmas(id)
);