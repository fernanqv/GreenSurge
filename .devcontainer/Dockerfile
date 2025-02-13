# Usar Rocky Linux 8 como base
FROM rockylinux:8

# Instalar dependencias básicas
RUN dnf install -y wget curl bzip2 gcc && \
    dnf clean all

# Definir variables de entorno para Miniconda
ENV CONDA_DIR=/opt/conda
ENV PATH="$CONDA_DIR/bin:$PATH"

# Descargar e instalar Miniconda
RUN curl -o Miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda.sh -b -p $CONDA_DIR && \
    rm Miniconda.sh

# Instalar Jupyter dentro del entorno base de Conda
#RUN conda install -y -n base jupyter python && \
#    conda clean -afy

#COPY environment.yml /environment.yml
#RUN conda env create -f /environment.yml && \
#    conda clean -afy

COPY environment.yml /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp
    
RUN wget -q http://personales.unican.es/fernanqv/delft3dfm_2024.03.tar.gz && \
    tar -xzvf delft3dfm_2024.03.tar.gz -C /opt/ && \
    rm delft3dfm_2024.03.tar.gz
    
ENV PATH="/opt/delft3dfm_2024.03:/opt/delft3dfm_2024.03/IntelMPI/mpi/latest/bin:/opt/delft3dfm_2024.03/lnx64/bin:/${PATH}"
