FROM haskell:8.0

RUN apt update && apt install --yes libpq-dev

WORKDIR /opt/server

COPY stack.yaml app.cabal /opt/server/
RUN stack install --only-dependencies -j3

COPY . /opt/server/
RUN stack install -j3

CMD ["app-exe"]
