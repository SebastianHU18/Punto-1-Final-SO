# ── BASE IMAGE ──────────────────────────────────────────────────────────────
# AWS provee imágenes oficiales optimizadas para Lambda.
FROM public.ecr.aws/lambda/python:3.11

# ── COPIAR DEPENDENCIAS ──────────────────────────────────────────────────────
COPY requirements.txt .

# ── INSTALAR DEPENDENCIAS ────────────────────────────────────────────────────
# --no-cache-dir → no guarda caché de pip, reduce el tamaño de la imagen.
RUN pip install --no-cache-dir -r requirements.txt -t ${LAMBDA_TASK_ROOT}

# ── COPIAR EL CÓDIGO ─────────────────────────────────────────────────────────
# Copiamos app.py al directorio de trabajo de Lambda (/var/task).
COPY app.py .

# ── DEFINIR EL HANDLER ───────────────────────────────────────────────────────
# CMD le dice a Lambda qué función invocar cuando llega un evento.
CMD ["app.mangum_handler"]
