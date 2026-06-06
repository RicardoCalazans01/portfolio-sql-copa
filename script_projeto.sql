-- ==========================================
-- ESTRUTURA DO BANCO DE DADOS (DDL)
-- ==========================================

CREATE TABLE TB_CIDADE (
    id_cidade INTEGER PRIMARY KEY AUTOINCREMENT,
    nm_cidade TEXT NOT NULL
);

CREATE TABLE TB_SELECAO (
    id_selecao INTEGER PRIMARY KEY AUTOINCREMENT,
    nm_selecao TEXT NOT NULL
);

CREATE TABLE TB_ESTADIO (
    id_estadio INTEGER PRIMARY KEY AUTOINCREMENT,
    nm_estadio TEXT NOT NULL,
    id_cidade INTEGER,
    FOREIGN KEY (id_cidade) REFERENCES TB_CIDADE(id_cidade)
);

CREATE TABLE TB_PARTIDA (
    id_partida INTEGER PRIMARY KEY AUTOINCREMENT,
    ano INTEGER NOT NULL,
    data_partida TEXT NOT NULL,
    fase TEXT NOT NULL,
    gols_mandante INTEGER NOT NULL,
    gols_visitante INTEGER NOT NULL,
    id_estadio INTEGER,
    id_mandante INTEGER,
    id_visitante INTEGER,
    FOREIGN KEY (id_estadio) REFERENCES TB_ESTADIO(id_estadio),
    FOREIGN KEY (id_mandante) REFERENCES TB_SELECAO(id_selecao),
    FOREIGN KEY (id_visitante) REFERENCES TB_SELECAO(id_selecao)
);

-- ==========================================
-- AS 15 CONSULTAS ANALÍTICAS (DML)
-- ==========================================

-- Consulta 1
SELECT e.nm_estadio, c.nm_cidade FROM TB_ESTADIO e INNER JOIN TB_CIDADE c ON e.id_cidade = c.id_cidade;

-- Consulta 2
SELECT p.ano, p.fase, m.nm_selecao AS mandante, v.nm_selecao AS visitante FROM TB_PARTIDA p INNER JOIN TB_SELECAO m ON p.id_mandante = m.id_selecao INNER JOIN TB_SELECAO v ON p.id_visitante = v.id_selecao;

-- Consulta 3
SELECT e.nm_estadio FROM TB_ESTADIO e LEFT JOIN TB_PARTIDA p ON e.id_estadio = p.id_estadio WHERE p.id_partida IS NULL;

-- Consulta 4
SELECT SUM(gols_mandante) AS total_gols_mandantes, SUM(gols_visitante) AS total_gols_visitantes FROM TB_PARTIDA;

-- Consulta 5
SELECT AVG(gols_mandante) AS media_gols_mandante FROM TB_PARTIDA;

-- Consulta 6
SELECT MAX(gols_mandante) AS maior_goleada_mandante FROM TB_PARTIDA;

-- Consulta 7
SELECT MIN(gols_visitante) AS menor_gols_visitante FROM TB_PARTIDA;

-- Consulta 8
SELECT COUNT(*) AS total_partidas_registradas FROM TB_PARTIDA;

-- Consulta 9
SELECT ano, SUM(gols_mandante) AS total_gols_ano FROM TB_PARTIDA GROUP BY ano;

-- Consulta 10
SELECT fase, COUNT(*) AS quantidade_partidas FROM TB_PARTIDA GROUP BY fase;

-- Consulta 11
SELECT ano, SUM(gols_mandante) AS total_gols FROM TB_PARTIDA GROUP BY ano HAVING SUM(gols_mandante) > 2;

-- Consulta 12
SELECT ano, fase, gols_mandante FROM TB_PARTIDA ORDER BY gols_mandante DESC;

-- Consulta 13
SELECT ano, fase, gols_mandante FROM TB_PARTIDA ORDER BY gols_mandante DESC LIMIT 2;

-- Consulta 14
SELECT ano, fase, gols_mandante FROM TB_PARTIDA ORDER BY gols_mandante DESC LIMIT 2 OFFSET 2;

-- Consulta 15
SELECT ano, AVG(gols_visitante) AS media_gols_visitantes FROM TB_PARTIDA GROUP BY ano ORDER BY ano ASC;