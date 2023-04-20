FROM public.ecr.aws/lambda/python:3.10

WORKDIR /work
RUN curl https://packages.microsoft.com/config/rhel/6/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN ACCEPT_EULA=Y \
  yum install -y \
  zip gzip tar openssl-devel msodbcsql17 \
  e2fsprogs.x86_64 0:1.43.5-2.43.amzn1 fuse-libs.x86_64 0:2.9.4-1.18.amzn1 libss.x86_64 0:1.43.5-2.43.amzn1 \
  && yum groupinstall "Development Tools" -y

COPY docker-entrypoint.sh .

ENTRYPOINT ["/work/docker-entrypoint.sh"]
# This is required to get the container to exit properly
CMD ["sleep", "1"] 
