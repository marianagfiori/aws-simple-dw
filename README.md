# AWS Simple Data Warehouse

Esse é um projeto de um data warehouse simples utilizando a stack Python com a biblioteca Pandas, AWS (S3, Glue e Redshift), Terraform e Airflow.
Os dados utilizados são de um e-commerce e foram divulgados publicamente através do Kaggle: <https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce>.

Primeiramente usei a ferramenta Terraform para construir a infraestrutura necessária para o desenvolvimento do projeto. Tal infraestrutura é composta por:

- Provider (AWS);
- IAM roles;
- Buckets;
- Glue crawlers;
- Glue jobs;
- Security Groups;
- Network (subnets);
- Cluster Redshift;

Já dentro da infraestrutura AWS, utilizando o Glue jobs com a opção de Jupyter Notebook, criei dois scripts:

- olist-raw-job:
A função desse script é de capturar os dados que estão no bucket 'raw' (bucket que contém os dados crus, sem nenhum tratamento) e os envia para o bucket 'cleaned'.

- olist-curate-transfer-job:
Esse script é responsável por pegar os dados do bucket 'cleaned' e fazer verificações, limpezas e transformações básicas necessárias aos dados. Por fim, ele salva os dados no formato parquet em subdiretórios divididos por datas (ano/mês/dia) dentro do bucket 'curated'.

Toda esse processo de carregamento e transformação é gerenciado pelo Airflow. Com essa ferramenta, pode-se criar uma função que verifica se algum arquivo novo cai no primeiro bucket (raw) e se positivo, chama um crawler para catalogar a tabela e aciona o Glue Job responsável pelo transporte até o segundo bucket 'curated'.

Após isso, novamente outra dag do Airflow faz a verificação de arquivo novo e, após isso, chama outro crawler e outro job resposável pelas transformações necessárias. Em seguida, as tabelas são colocadas no bucket 'curated' onde, assim que são detectadas pelos sensores do Airflow, são catalogadas novamente e então transferidas para o Redshift.

Após a construção do data warehouse, fiz uma conexão com a ferramenta Power Bi e elaborei um dashboard simples com algumas informações relevantes sobre as vendas realizadas no e-commerce.

![olist-project-dashboard](/2023-06-26.png)
