# 🏆 Portfólio SQL: Engenharia Reversa, Normalização e Análise Histórica da Copa do Mundo

## 🎬 1. Vídeo de Demonstração
* [Clique aqui para assistir ao Pitch de Demonstração (Máximo 1 Minuto)](https://drive.google.com/drive/folders/1kHx7RzhnnYFFYjgINhPjKGIaIjEG6xC-?usp=drive_link)
> *Nota: O link acima será atualizado assim que a gravação do pitch de 1 minuto for concluída.*

---

## 🎓 2. Certificados DataCamp
* [Clique aqui para visualizar o Certificado de Nivelamento SQL](https://drive.google.com/drive/folders/1Sgx-mrifMBkxPb-B4YyRP8TSOkqKgVwg?usp=sharing)
> *Nota: O link acima será atualizado com a imagem/link de comprovação do módulo concluído.*

---

## 📐 3. Modelo Entidade-Relacionamento (Processo de Normalização)

### Antes (Arquivo Bruto .CSV)
O arquivo original extraído do Kaggle apresentava redundâncias textuais graves, repetindo dados de cidades, seleções e estádios textualmente em milhares de linhas, violando as formas normais.

### Depois (Modelagem Otimizada em 3FN)
Após o processo de engenharia reversa e aplicação das regras até à **Terceira Forma Normal (3FN)**, a estrutura foi dividida em tabelas lógicas interligadas por Chaves Primárias `[PK]` e Chaves Estrangeiras `[FK]`:

* **TB_CIDADE** (`id_cidade` [PK], `nm_cidade`)
* **TB_SELECAO** (`id_selecao` [PK], `nm_selecao`)
* **TB_ESTADIO** (`id_estadio` [PK], `nm_estadio`, `id_cidade` [FK -> TB_CIDADE])
* **TB_PARTIDA** (`id_partida` [PK], `ano`, `data_partida`, `fase`, `gols_mandante`, `gols_visitante`, `id_estadio` [FK -> TB_ESTADIO], `id_mandante` [FK -> TB_SELECAO], `id_visitante` [FK -> TB_SELECAO])

---

## 📊 4. Dossiê das Consultas (Tabela de Negócio)

| N° | Pergunta de Negócio | Código SQL | Justificativa de Inovação Analítica |
| :---: | :--- | :--- | :--- |
| **1** | Relação de estádios cadastrados e as suas respetivas cidades. | `SELECT e.nm_estadio, c.nm_cidade FROM TB_ESTADIO e INNER JOIN TB_CIDADE c ON e.id_cidade = c.id_cidade;` | Transforma chaves numéricas em relatórios textuais através da primeira junção relacional (`INNER JOIN`). |
| **2** | Lista de partidas exibindo o ano, fase, nome do mandante e do visitante. | `SELECT p.ano, p.fase, m.nm_selecao AS mandante, v.nm_selecao AS visitante FROM TB_PARTIDA p INNER JOIN TB_SELECAO m ON p.id_mandante = m.id_selecao INNER JOIN TB_SELECAO v ON p.id_visitante = v.id_selecao;` | Resolve a legibilidade da tabela de factos fazendo um duplo `INNER JOIN` na mesma tabela de domínio (`TB_SELECAO`). |
| **3** | Auditoria para encontrar estádios que não possuem nenhuma partida associada. | `SELECT e.nm_estadio FROM TB_ESTADIO e LEFT JOIN TB_PARTIDA p ON e.id_estadio = p.id_estadio WHERE p.id_partida IS NULL;` | Usa `LEFT JOIN` e `IS NULL` para criar uma query de integridade que deteta registos órfãos ou inconsistências na base de dados. |
| **4** | Volume total de gols acumulados por mandantes e visitantes na história. | `SELECT SUM(gols_mandante) AS total_gols_mandantes, SUM(gols_visitante) AS total_gols_visitantes FROM TB_PARTIDA;` | Agrega dados macro através da função matemática `SUM()` aplicada em colunas paralelas de métricas. |
| **5** | Média geral de gols marcados exclusivamente pelas equipas mandantes. | `SELECT AVG(gols_mandante) AS media_gols_mandante FROM TB_PARTIDA;` | Extrai indicadores estatísticos (`AVG`) para avaliar o fenómeno do "fator casa" nos torneios mundiais. |
| **6** | Maior número de gols marcados por um mandante numa única partida. | `SELECT MAX(gols_mandante) AS maior_goleada_mandante FROM TB_PARTIDA;` | Identifica picos de desempenho e recordes históricos utilizando a função agregada de teto `MAX()`. |
| **7** | Menor número de gols marcados por uma equipa visitante. | `SELECT MIN(gols_visitante) AS menor_gols_visitante FROM TB_PARTIDA;` | Mede a eficiência defensiva extrema ("baliza a zeros") utilizando a função agregada de piso `MIN()`. |
| **8** | Quantidade total de partidas oficiais registadas na base de dados. | `SELECT COUNT(*) AS total_partidas_registradas FROM TB_PARTIDA;` | Auditoria volumétrica elementar via `COUNT(*)` para monitorizar o sucesso e consistência da carga de dados. |
| **9** | Total de gols acumulados dos mandantes agrupados por ano. | `SELECT ano, SUM(gols_mandante) AS total_gols_ano FROM TB_PARTIDA GROUP BY ano;` | Introduz partições temporais combinando a agregação com a cláusula de quebra relacional `GROUP BY`. |
| **10** | Quantidade de partidas realizadas distribuídas por cada fase do torneio. | `SELECT fase, COUNT(*) AS quantidade_partidas FROM TB_PARTIDA GROUP BY fase;` | Classifica o volume de dados da base por categorias textuais, aliando `GROUP BY` e `COUNT()`. |
| **11** | Anos em que a soma de gols dos mandantes foi estritamente maior que 2 gols. | `SELECT ano, SUM(gols_mandante) AS total_gols FROM TB_PARTIDA GROUP BY ano HAVING SUM(gols_mandante) > 2;` | Implementa a cláusula avançada `HAVING`, executando filtros em resultados que já sofreram agrupamento agregativo. |
| **12** | Ranking de partidas ordenadas decrescentemente pelos gols dos mandantes. | `SELECT ano, fase, gols_mandante FROM TB_PARTIDA ORDER BY gols_mandante DESC;` | Constrói tabelas de classificação competitiva através da ordenação sequencial explícita com `ORDER BY DESC`. |
| **13** | Top 2 partidas com as maiores goleadas de equipas mandantes. | `SELECT ano, fase, gols_mandante FROM TB_PARTIDA ORDER BY gols_mandante DESC LIMIT 2;` | Limita a cardinalidade de saída (`LIMIT`), mimetizando a lógica de ecrãs de destaques ou *Top Competitors*. |
| **14** | Exclusão do Top 2, trazendo as duas partidas seguintes no ranking de gols. | `SELECT ano, fase, gols_mandante FROM TB_PARTIDA ORDER BY gols_mandante DESC LIMIT 2 OFFSET 2;` | Domina técnicas avançadas de paginação e navegação de dados analíticos através do par `LIMIT` e `OFFSET`. |
| **15** | Média de gols dos visitantes por ano, ordenados do mais antigo ao mais recente. | `SELECT ano, AVG(gols_visitante) AS media_gols_visitantes FROM TB_PARTIDA GROUP BY ano ORDER BY ano ASC;` | **Query de Fecho de Portfólio:** Orquestra projeções matemáticas (`AVG`), agrupamento categórico (`GROUP BY`) e ordenação cronológica (`ORDER BY ASC`) num relatório de inteligência de negócio. |
