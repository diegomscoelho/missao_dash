# <img src="fig/onca.svg" alt="drawing" width="20"/> missao_dash 

Este repositório foi criado para gerar um dashboard em quarto com uma automação diária para apoiamentos diários ao partido missão.

## Dependencies

If you want to create an enviroment to run scripts locally:

1) Install conda, if necessary;
2) Run `conda env create -f env.yml`

## Data

1) Tabela de votos válidos / apoiamento minimo em 2023. (data/tse.tsv)
https://www.tse.jus.br/partidos/criacao-de-partido/arquivos/tabela-com-o-quantitativo-do-apoiamento-minimo-de-eleitores-2023
2) `get_MBL.R` está pegando diariamente os dados do TSE na parte de formação de partidos; (data/mbl.csv)
3) `data/BR.*` são os arquivos necessários para plotar o mapa estático.