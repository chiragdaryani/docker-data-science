FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    openssl \
    libssl-dev \
    libbz2-dev \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev \
    curl \
    unixodbc-dev \
    cmake \
    wget \
    freetds-dev \
    freetds-bin \
    tdsodbc \
    python3-pip

#Requirements for pymssql: https://learn.microsoft.com/en-us/sql/connect/python/pymssql/step-1-configure-development-environment-for-pymssql-python-development?source=recommendations&view=sql-server-ver16

# Download and install spedific OpenSSL (1.1.1p)
RUN wget https://www.openssl.org/source/openssl-1.1.1p.tar.gz -O openssl-1.1.1p.tar.gz && \
    tar -zxvf openssl-1.1.1p.tar.gz && \
    cd openssl-1.1.1p && \
    ./config && \
    make && \
    make install && \
    ldconfig

# Install Microsoft ODBC Driver for SQL Server
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# Download and install the Snowflake ODBC driver
RUN curl -O https://sfc-repo.snowflakecomputing.com/odbc/linux/latest/snowflake-odbc-2.21.0.x86_64.deb && \
    dpkg -i snowflake-odbc-2.21.0.x86_64.deb && \
    rm snowflake-odbc-2.21.0.x86_64.deb

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install numpy pandas pymssql SQLAlchemy boto3 requests snowflake-connector-python snowflake-sqlalchemy scikit-learn workalendar awswrangler s3transfer --no-cache

WORKDIR /usr/src

ENV PYTHONUNBUFFERED=TRUE

ENTRYPOINT ["python3"]
