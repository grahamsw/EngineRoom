cd port_test/sc
docker build -t grahamsw/port_test_sc:latest .
docker push grahamsw/port_test_sc:latest
cd ../..

cd port_test/python
docker build -t grahamsw/port_test_py:latest .
docker push grahamsw/port_test_py:latest
cd ../..

cd port_test_2/sc
docker build -t grahamsw/port_test_2_sc:latest .
docker push grahamsw/port_test_2_sc:latest
cd ../..

cd port_test_2/python
docker build -t grahamsw/port_test_2_py:latest .
docker push grahamsw/port_test_2_py:latest
cd ../..



