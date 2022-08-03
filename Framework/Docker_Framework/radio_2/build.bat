REM I'm running this on Windows, so it's a batch file. 

SET REPO=grahamsw/radio_2

cd sc
docker build -t %REPO%:sc .
docker push %REPO%:sc
cd ..

cd py
docker build -t %REPO%:py .
docker push %REPO%:py
cd ..

