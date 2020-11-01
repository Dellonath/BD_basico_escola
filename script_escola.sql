CREATE TABLE Aluno(
	CPF INT PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	matricula INT NOT NULL
);

CREATE TABLE Professor(
	CPF INT PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	salario FLOAT NOT NULL CHECK (salario >= 0)
);

CREATE TABLE Disciplina(
	ID INT PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	numeroCreditos INT NOT NULL CHECK (numeroCreditos >= 0),
	idRegente INT NOT NULL,
	FOREIGN KEY (idRegente) REFERENCES Professor(CPF)
);

CREATE TABLE Turma(
	ID INT PRIMARY KEY,
	sala VARCHAR(5) NOT NULL,    -- receberá dados como C1102, bloco C, primeiro andar, sala 102
	horario VARCHAR(10) NOT NULL, -- algo como 2M12 segunda nos dois primeiros horários da manhã
	idProfessor INT NOT NULL,
	idDisciplina INT NOT NULL,
	FOREIGN KEY (idProfessor) REFERENCES Professor(CPF),
	FOREIGN KEY (idDisciplina) REFERENCES Disciplina(ID)
);
	
CREATE TABLE Prova(
	ID SERIAL PRIMARY KEY, -- o ID de prova será fornecido automaticamente com valores entre de 1 e 2.147.483.647
	valor INT CHECK (valor >= 0 AND valor <= 10), -- provas de pontuação mínima 0 e máxima 10
	descricao VARCHAR(50) NOT NULL,
	idDisciplina INT NOT NULL,
	FOREIGN KEY (idDisciplina) REFERENCES Disciplina(ID)
		ON DELETE CASCADE 
);

CREATE TYPE tipoStatus AS ENUM ('pendente', 'cursando', 'finalizada');
CREATE TABLE Matriculado(
	idAluno INT NOT NULL,
	idTurma INT NOT NULL,
	PRIMARY KEY (idAluno, idTurma),
	status tipoStatus,
	FOREIGN KEY (idAluno) REFERENCES Aluno(CPF),
	FOREIGN KEY (idTurma) REFERENCES Turma(ID)
);

CREATE TABLE Faz(
	idAluno INT NOT NULL,
	idProva INT NOT NULL,
	PRIMARY KEY (idAluno, idProva),
	nota FLOAT CHECK (nota >= 0 AND nota <= 10),
	FOREIGN KEY (idAluno) REFERENCES Aluno(CPF)
		ON DELETE CASCADE,
	FOREIGN KEY (idProva) REFERENCES Prova(ID)
);

CREATE TABLE Pertence(
	idDisciplina INT NOT NULL,
	idProva INT NOT NULL,
	FOREIGN KEY (idDisciplina) REFERENCES Disciplina(ID)
		ON DELETE CASCADE,
	FOREIGN KEY (idProva) REFERENCES Prova(ID)
);

INSERT INTO Aluno VALUES (1847263849, 'Marcelo Seivas', 2019011958), (1328683743, 'Camilla Arruda', 2020019947);
INSERT INTO Professor VALUES (1827672698, 'Rafael Ramos', 10437.57), (898772646, 'Otávio Bragatini', 9847.23);
INSERT INTO Disciplina VALUES (1, 'Programação I', 64, 1827672698), (2, 'Cálculo I', 96, 898772646);
INSERT INTO Turma VALUES (1, 'C1105', '2N12 5N12', 1827672698, 1), (2, 'B4105', '4M34 5T12', 898772646, 2);
INSERT INTO Prova VALUES
	(DEFAULT, 10, 'Prova de Lista encadeada e Árvore Binária', 1), 
	(DEFAULT, 10, 'Prova de Derivada e Integral', 2);
INSERT INTO Matriculado VALUES (1847263849, 1, 'cursando'), (1328683743, 2, 'finalizada');
INSERT INTO Faz VALUES (1847263849, 1, 8.7), (1328683743, 2, 8.9);
INSERT INTO Pertence VALUES (1, 1), (2, 2);


