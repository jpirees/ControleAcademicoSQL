USE ControleAcademico;

CREATE TABLE aluno (
	ra VARCHAR(15) NOT NULL,
	cpf VARCHAR(15) NOT NULL UNIQUE,
	nome VARCHAR(60) NOT NULL,

	CONSTRAINT pk_aluno PRIMARY KEY (ra)
);

CREATE TABLE disciplina (
	codigo VARCHAR(10) NOT NULL,
	nome VARCHAR(60) NOT NULL UNIQUE,
	carga_horaria FLOAT NOT NULL,

	CONSTRAINT pk_codigo PRIMARY KEY (codigo)
);

CREATE TABLE matricula (
	ano INT NOT NULL,
	semestre INT NOT NULL,
	codigo_disciplina VARCHAR(10) NOT NULL,
	ra_aluno VARCHAR(15) NOT NULL,
	nota1 FLOAT,
	nota2 FLOAT,
	nota_substutiva FLOAT,
	media_final FLOAT,
	faltas FLOAT,
	situacao VARCHAR(30)

	CONSTRAINT fk_codigo_disciplina_matricula FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo),
	CONSTRAINT fk_ra_aluno_matricula FOREIGN KEY (ra_aluno) REFERENCES aluno(ra),
	CONSTRAINT pk_matricula PRIMARY KEY (ano, semestre, codigo_disciplina, ra_aluno)
);


SELECT * FROM aluno;

SELECT * FROM disciplina;

SELECT * FROM matricula;

-- [codigo_disciplina, ano]
EXECUTE dbo.AlunosMatriculadosNaDisciplina 'LIN100', 2021;

-- [aluno, ano, semestre]
EXECUTE dbo.BuscaBoletimDeAluno '0220212019005', 2021, 2;

-- [ano]
EXECUTE dbo.AlunosReprovadosPorNota 2021;
