# Usar Rocky Linux 8 como base
FROM rockylinux:8

# Instalar dependencias básicas
RUN dnf install -y wget curl bzip2 && \
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

COPY environment.yml /environment.yml
RUN conda env create -f /environment.yml && \
    conda clean -afy

# Establecer el usuario por defecto
USER root
