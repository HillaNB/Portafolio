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
- 5 tablas relacionadas (Clientes, Productos, Transacciones)  
- Validaciones con constraints (`CHECK`, `PK`, `FK`)  

📂 **Archivos:**  
- [Script SQL](./proyecto-facturacion/SistemaFacturacion.sql)  
- [Documentación técnica](./proyecto-facturacion/README.md)  

🖼️ **Diagrama:**  
![ER Diagram](./proyecto-facturacion/images/diagrama-er.png)  

🚀 **Cómo ejecutar:**  
```sql
conn sys/506UH as sysdba;
@SistemaFacturacion.sql
