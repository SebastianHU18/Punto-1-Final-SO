### Comandos Punto 1

•	Nano Dockerfile
•	aws sts get-caller-identity --query Account --output text
•	aws sts get-caller-identity
•	chmod +x deploy.sh
•	./deploy.sh
- 
-
•	Se crea la function
•	docker rmi $(docker images | grep lambda-final-repo | awk '{print $3}') –force
•	docker images --format "{{.Repository}}:{{.Tag}}" | grep lambda-final-repo
•	docker rmi 911526871150.dkr.ecr.us-east-2.amazonaws.com/lambda-final-repo:latest –force
-
-
•	curl https://rkxo7lnrb4zjcnnxr2cbxgr2ky0fbnwt.lambda-url.us-east-2.on.aws/
•	curl https://rkxo7lnrb4zjcnnxr2cbxgr2ky0fbnwt.lambda-url.us-east-2.on.aws/api/hello?name=sebas
-
-
Enlace a chat con IA
https://claude.ai/share/0fcfc11c-a263-4046-8b24-7fe71316fa67
 

