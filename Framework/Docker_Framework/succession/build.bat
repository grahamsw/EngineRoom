
SET REPO=grahamsw/radio

cd sc
docker build -t %REPO%:sc .
docker push %REPO%:sc
cd ..

cd py
docker build -t %REPO%:py .
docker push %REPO%:py
cd ..

