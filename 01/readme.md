##1. Храним пароли и личную информацию в personal.auto.tfvars 
##2. Секретное седержимое random_password - "result": "eZLaw0Imfv0GfBYs"
 <img width="845" height="976" alt="Снимок экрана от 2026-04-09 12-10-18" src="https://github.com/user-attachments/assets/936ce4ef-df49-4910-9578-49b1a4a4cd1e" />
##3. Ошибки в расскоментированом блоке
<img width="701" height="808" alt="Снимок экрана от 2026-04-09 12-11-01" src="https://github.com/user-attachments/assets/51be663b-8097-4d13-a9a6-dc4e4fe843f4" />
<img width="1277" height="1364" alt="Снимок экрана от 2026-04-09 12-13-05" src="https://github.com/user-attachments/assets/7ddc4815-a3b6-494d-8c0a-20a78d91c9b9" />
##4. Замена имени контейнера
Опасность в том, что если применить авто-одобрение, то эти изменения будут автоматически приняты и добавлены в сборку. Это может привести к неожиданному изменению кода и возможному нарушению работы приложения. Не стоит использовать в ответственных местах. Удобно использовать при обучении, локальном тестировании сборок.
<img width="1122" height="70" alt="Снимок экрана от 2026-04-09 12-20-24" src="https://github.com/user-attachments/assets/3cfddb18-87e8-43c6-8fd7-e9fe11aa091d" />
##5. Terraform destroy
<img width="822" height="212" alt="Снимок экрана от 2026-04-09 12-23-09" src="https://github.com/user-attachments/assets/69d33cf8-189f-4d13-a350-081ddd993a4f" />
Образ не удаляется потому что в конфигурационном файле задан аргумент: keep_locally – true, если его сменить на false, то при уничтожении ресурсов с помощью terraform образы тоже удалятся.
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
