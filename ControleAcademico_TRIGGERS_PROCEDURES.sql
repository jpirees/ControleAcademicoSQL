--USE ControleAcademico;

--CREATE OR ALTER PROCEDURE AlunosMatriculadosNaDisciplina
--@DISCIPLINA VARCHAR(10),
--@ANO INT
--AS
--BEGIN
--	SELECT a.ra, a.nome, d.codigo, d.nome AS disciplina, m.ano, m.semestre, m.nota1, m.nota2, m.nota_substutiva, m.media_final, m.faltas, m.situacao 
--	FROM ControleAcademico.dbo.matricula m, ControleAcademico.dbo.aluno a, ControleAcademico.dbo.disciplina d
--	WHERE m.codigo_disciplina = @DISCIPLINA AND m.ano = @ANO AND m.ra_aluno = a.ra AND m.codigo_disciplina = d.codigo;
--END;



-- #######################################################################################################################################



--CREATE OR ALTER PROCEDURE BuscaBoletimDeAluno
--@RA VARCHAR(15),
--@ANO INT,
--@SEMESTRE INT
--AS
--BEGIN
--	SELECT a.ra, a.nome, d.codigo, d.nome AS disciplina, m.ano, m.semestre, m.nota1, m.nota2, m.nota_substutiva, m.media_final, m.faltas, (d.carga_horaria * 0.25) AS faltas_permitidas, m.situacao 
--	FROM ControleAcademico.dbo.matricula m, ControleAcademico.dbo.aluno a, ControleAcademico.dbo.disciplina d
--	WHERE m.ano = @ANO AND m.semestre = @SEMESTRE AND m.codigo_disciplina = d.codigo AND m.ra_aluno = a.ra AND m.ra_aluno = @RA
--	ORDER BY d.nome ASC;
--END;



-- #######################################################################################################################################



--CREATE OR ALTER PROCEDURE AlunosReprovadosPorNota
--@ANO INT
--AS
--BEGIN
--	SELECT a.ra, a.nome, d.codigo, d.nome AS disciplina, m.ano, m.semestre, m.nota1, m.nota2, m.nota_substutiva, m.media_final, m.faltas, m.situacao 
--	FROM ControleAcademico.dbo.matricula m, ControleAcademico.dbo.aluno a, ControleAcademico.dbo.disciplina d
--	WHERE m.ano = @ANO AND m.codigo_disciplina = d.codigo AND m.ra_aluno = a.ra AND m.situacao = 'REPROVADO POR NOTA'
--	ORDER BY d.nome, a.nome ASC;
--END



-- #######################################################################################################################################



--CREATE OR ALTER TRIGGER AtualizaMediaSituacao
--ON ControleAcademico.dbo.matricula
--INSTEAD OF INSERT
--AS
--BEGIN
--	DECLARE
--		@ANO INT,
--		@SEMESTRE INT,
--		@RA_ALUNO VARCHAR(15),
--		@CODIGO_DISCIPLINA VARCHAR(10),
--		@NOTA1 FLOAT,
--		@NOTA2 FLOAT,
--		@NOTA_SUB FLOAT,
--		@MEDIA_FINAL FLOAT,
--		@FALTAS FLOAT,
--		@FALTAS_PERMITIDAS FLOAT,
--		@SITUACAO VARCHAR(30);

--	DECLARE _cursor CURSOR FOR
--	SELECT ano, semestre, ra_aluno, codigo_disciplina, nota1, nota2, nota_substutiva, media_final, faltas
--	FROM INSERTED;

--	OPEN _cursor
--	FETCH NEXT FROM _cursor 
--	INTO @ANO, @SEMESTRE, @RA_ALUNO, @CODIGO_DISCIPLINA, @NOTA1, @NOTA2, @NOTA_SUB, @MEDIA_FINAL, @FALTAS 
--	WHILE @@FETCH_STATUS = 0
--	BEGIN

--		SELECT @FALTAS_PERMITIDAS = (carga_horaria * 0.25)
--		FROM ControleAcademico.dbo.disciplina d
--		WHERE d.codigo = @CODIGO_DISCIPLINA;

--		IF (@NOTA_SUB IS NULL)
--		BEGIN
--			SET @NOTA_SUB = 0.00
--			SET @MEDIA_FINAL = (@NOTA1 + @NOTA2) / 2;
--		END
--		ELSE
--		BEGIN
--			IF @NOTA1 >= @NOTA2
--				SET @MEDIA_FINAL = (@NOTA1 + @NOTA_SUB) / 2;
--			ELSE IF (@NOTA2 >= @NOTA1)
--				SET @MEDIA_FINAL = (@NOTA_SUB + @NOTA2) / 2;
--			ELSE
--				SET @MEDIA_FINAL = (@NOTA_SUB + @NOTA2) / 2;
--		END


--		IF @MEDIA_FINAL >= 5
--			SET @SITUACAO = 'APROVADO';
--		ELSE
--			SET @SITUACAO = 'REPROVADO POR NOTA';

--		IF (@SITUACAO = 'REPROVADO POR NOTA' AND @FALTAS > @FALTAS_PERMITIDAS)
--			SET @SITUACAO = 'REPROVADO POR FALTA'

--		INSERT INTO ControleAcademico.dbo.matricula (ano, semestre, ra_aluno, codigo_disciplina, nota1, nota2, nota_substutiva, media_final, faltas, situacao)
--		VALUES (@ANO, @SEMESTRE, @RA_ALUNO, @CODIGO_DISCIPLINA, @NOTA1, @NOTA2, @NOTA_SUB, @MEDIA_FINAL, @FALTAS, @SITUACAO);

--		FETCH NEXT FROM _cursor 
--		INTO @ANO, @SEMESTRE, @RA_ALUNO, @CODIGO_DISCIPLINA, @NOTA1, @NOTA2, @NOTA_SUB, @MEDIA_FINAL, @FALTAS 
--	END
--	CLOSE _cursor
--	DEALLOCATE _cursor
--END;