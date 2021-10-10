
cd sc
docker build -t grahamsw/chimes:sc .
docker push grahamsw/chimes:sc
cd ..

cd py
docker build -t grahamsw/chimes:py .
docker push grahamsw/chimes:py
cd ../..
