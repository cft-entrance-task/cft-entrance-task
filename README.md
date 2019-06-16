# CFT entrance task:
## Project structure
* `documents/deployment-schemas` deployment schema of HL stand
* `documents/postman` Postman collection of API requests (can be used to validate stand)
* `src` directory with ansible scripts for stand/services deployment and running test
* `main.sh` entrypoint for project

## Stand deployment:
1. Install requirements `./main.sh prepare`
2. Fill AWS keys in `src/roles/aws/defaults/main.yml`
3. Add API token for Overload.Yandex in `src/roles/loadgenerator/files/overload-token`
4. Use `./main.sh getStand` to request instances in AWS EC2
5. Use `./main.sh deployServices` to deploy services on instances

## Running test:
1. Use `./main.sh runLoadTest` to launch test
2. See results on [Overload.Yandex](https://overload.yandex.net/ "Overload.Yandex")

