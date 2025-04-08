# 💻 Portafolio 
**Nombre:** Hillary Blandón Brenes
**Universidad:** Universidad Hispanoamericana

## 📂 Proyectos

---

### 1. 🏦 Sistema de Facturación Oracle SQL  

📅 **Fecha:** Octubre 2024 
## ⚙️ Tecnologías y Herramientas
- Oracle SQL
- SQL*Plus o SQL Developer

📋 **Descripción:**  
Este proyecto consiste en un sistema de facturación completo, diseñado en Oracle SQL. Se implementaron las siguientes funcionalidades clave:  
- Creación de tablespaces (`DATOS`, `INDICES`)  
- 5 tablas relacionadas (Clientes, Productos, Transacciones, Detalle_Factura y Encabezado)  
- Validaciones con constraints (`CHECK`, `PK`, `FK`)  

🚀 **Cómo ejecutar:**  
```sql
conn sys/506UH as sysdba;
@SistemaFacturacion.sql
