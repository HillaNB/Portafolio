# 💻 Portafolio 
**Nombre:** Hillary Blandón Brenes
**Universidad:** Universidad Hispanoamericana

## 📂 Proyectos

---

### 1. 🏦 Sistema de Facturación Oracle SQL  
📅 **Fecha:** Octubre 2024  
🛠 **Tecnologías:** Oracle Database, SQL*Plus  

📋 **Descripción:**  
Sistema completo de facturación con:  
- Creación de tablespaces (`DATOS`, `INDICES`)  
- 5 tablas relacionadas (Clientes, Productos, Transacciones, Detalle_Factura y Encabezado)  
- Validaciones con constraints (`CHECK`, `PK`, `FK`)  

🚀 **Cómo ejecutar:**  
```sql
conn sys/506UH as sysdba;
@SistemaFacturacion.sql
