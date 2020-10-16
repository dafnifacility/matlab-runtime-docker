FROM ubuntu:18.04 as prebuilder

# Install pre-requisites
RUN mkdir -p /matlab-runtime /opt/matlab-runtime/v98/archives /code/model && \ 
    apt-get -q update && \
    apt-get install -q -y --no-install-recommends \
      xorg \
      unzip \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /matlab-runtime

# Download and install Matlab runtime
RUN wget https://ssd.mathworks.com/supportfiles/downloads/R2020a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020a_Update_5_glnxa64.zip && \
    unzip MATLAB_Runtime_R2020a_Update_5_glnxa64.zip && \
    rm -rf MATLAB_Runtime_R2020a_Update_5_glnxa64.zip && \
    ./install -destinationFolder /opt/matlab-runtime -agreeToLicense yes -mode silent -outputFile /log.txt $$ \
    rm -rf /matlab-runtime

# Point to the newly installed Matlab runtime binaries
ENV LD_LIBRARY_PATH /opt/matlab-runtime/v98:/opt/matlab-runtime/v98/runtime/glnxa64:/opt/matlab-runtime/v98/bin/glnxa64:/opt/matlab-runtime/v98/sys/os/glnxa64:/opt/matlab-runtime/v98/sys/opengl/lib/glnxa64:/opt/matlab-runtime/v98/extern/bin/glnxa64

WORKDIR /code/model

# Add the compiled model executable to the image
ADD helloWorld /code/model

# Run the model and print out the file that is produced by this model
CMD ./helloWorld && cat file.txt