
rem  port_test/sc
rem docker build -t grahamsw/port_test_sc:latest .
rem docker push grahamsw/port_test_sc:latest
rem cd ../..

rem cd port_test/python
rem docker build -t grahamsw/port_test_py:latest .
rem docker push grahamsw/port_test_py:latest
rem cd ../..

cd port_test_2/sc
docker build -t grahamsw/port_test_2_sc:latest .
docker push grahamsw/port_test_2_sc:latest
cd ../..

cd port_test_2/python
docker build -t grahamsw/port_test_2_py:latest .
docker push grahamsw/port_test_2_py:latest
cd ../..


cd radio_2/sc
docker build -t grahamsw/sc_radio_2:latest .
docker push grahamsw/sc_radio_2:latest
cd ../..

cd radio_2/py
docker build -t grahamsw/python_docker_dk2:latest .
docker push grahamsw/python_docker_dk2:latest
cd ../..



