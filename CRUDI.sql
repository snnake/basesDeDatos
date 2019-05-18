CREATE OR REPLACE PACKAGE BODY CRUD_PRODUCTOS IS
PROCEDURE INSERTAR_PRODUCTOS(XCANTIDAD IN PRODUCTOS.CANTIDAD%TYPE, XPRECIO IN PRODUCTOS.PRECIO%TYPE, XCATEGORIA IN PRODUCTOS.CATEGORIA%TYPE, XMARCA IN PRODUCTOS.MARCA%TYPE)
IS
BEGIN
INSERT INTO PRODUCTOS VALUES(NULL,XCANTIDAD,XPRECIO,XCATEGORIA,XMARCA);
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20001,'Se ha hecho mal la inserci�n');
END INSERTAR_PRODUCTOS;
PROCEDURE BORRAR_PRODUCTOS(XNUMERO IN PRODUCTOS.NUMERO%TYPE)
IS 
BEGIN
DELETE FROM PRODUCTOS WHERE NUMERO = XNUMERO;
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20002,'Se ha hecho mal el borrado');
END BORRAR_PRODUCTOS;
PROCEDURE ACTUALIZAR_PRODUCTOS(XNUMERO IN PRODUCTOS.NUMERO%TYPE, XCANTIDAD IN PRODUCTOS.CANTIDAD%TYPE, XPRECIO IN PRODUCTOS.PRECIO%TYPE)
IS
BEGIN
UPDATE PRODUCTOS SET CANTIDAD=XCANTIDAD, PRECIO=XPRECIO
WHERE NUMERO = XNUMERO;
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20003,'Se ha hecho mal la actualizaci�n');
END ACTUALIZAR_PRODUCTOS;
PROCEDURE CONSULTAR_PRODUCTOS(CURSOR1 OUT SYS_REFCURSOR)
AS
BEGIN
OPEN CURSOR1 FOR
SELECT PROOVEDORES.NUMERO,PROOVEDORES.NOMBREEMPRESA,PEDIDOS.CANTIDADPRODUCTOS,DESPACHOS.FECHAENVIO FROM PROOVEDORES JOIN PEDIDOS ON (PROOVEDORES.NUMERO = PEDIDOS.PROOVEDOR) JOIN DESPACHOS ON (PEDIDOS.DESPACHO = DESPACHOS.NUMERO)
WHERE PRECIOVENTA > 5000000;
END CONSULTAR_PRODUCTOS;
PROCEDURE INSERTAR_DESCRIPCIONES(XDETALLE IN DESCRIPCIONES.DETALLE%TYPE, XPRODUCTO IN DESCRIPCIONES.PRODUCTO%TYPE)
IS
BEGIN
INSERT INTO DESCRIPCIONES VALUES(NULL,XDETALLE,XPRODUCTO);
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20004,'Se ha hecho mal la inserci�n');
END INSERTAR_DESCRIPCIONES;
PROCEDURE BORRAR_DESCRIPCIONES(XNUMERO IN DESCRIPCIONES.NUMERO%TYPE)
IS 
BEGIN
DELETE FROM DESCRIPCIONES WHERE NUMERO=XNUMERO;
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20005,'Se ha hecho mal el borrado');
END BORRAR_DESCRIPCIONES;
PROCEDURE ACTUALIZAR_DESCRIPCIONES(XNUMERO IN DESCRIPCIONES.NUMERO%TYPE, XDETALLE IN DESCRIPCIONES.DETALLE%TYPE)
IS 
BEGIN
UPDATE DESCRIPCIONES SET DETALLE = XDETALLE
WHERE NUMERO = XNUMERO;
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20006,'Se ha hecho mal la actualizaci�n');
END ACTUALIZAR_DESCRIPCIONES;
PROCEDURE CONSULTAR_DESCRIPCIONES(CURSOR2 OUT SYS_REFCURSOR) AS
BEGIN
OPEN CURSOR2 FOR
SELECT * FROM DESCRIPCIONES;
END CONSULTAR_DESCRIPCIONES;
PROCEDURE INSERTAR_TIENE(XPEDIDO IN PERTENENCIAS.PEDIDO%TYPE,XPRODUCTO IN PERTENENCIAS.PRODUCTO%TYPE,XTAMA�O IN PERTENENCIAS.TAMA�O%TYPE,XCOLOR IN PERTENENCIAS.COLOR%TYPE,XA�OPRODUCTO IN PERTENENCIAS.A�OPRODUCTOS%TYPE)
IS
BEGIN
INSERT INTO PERTENENCIAS VALUES(XPRODUCTO,XPEDIDO,XTAMA�O,XCOLOR,XA�OPRODUCTO);
COMMIT;
EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;
RAISE_APPLICATION_ERROR(-20007,'Se ha hecho mal la inserci�n');
END INSERTAR_TIENE;
PROCEDURE CONSULTAR_TIENE(CURSOR3 OUT SYS_REFCURSOR)
AS
BEGIN
OPEN CURSOR3 FOR
SELECT * FROM PERTENENCIAS;
END CONSULTAR_TIENE;
END;
/
CREATE OR REPLACE PACKAGE BODY CRUD_PROOVEDOR IS
    PROCEDURE AD_PROOVEDORES(XTELEFONO IN PROOVEDORES.TELEFONO%TYPE, XNOMBREEMPRESA IN PROOVEDORES.NOMBREEMPRESA%TYPE, XNIT IN PROOVEDORES.NIT%TYPE, XURL IN PROOVEDORES.URL%TYPE)
    IS
    BEGIN
        INSERT INTO PROOVEDORES VALUES(10000000,XTELEFONO,XNOMBREEMPRESA,XNIT,XURL);
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001,SQLERRM);
    END;
    PROCEDURE MO_PROOVEDORES(XTELEFONO IN PROOVEDORES.TELEFONO%TYPE, XNOMBREEMPRESA IN PROOVEDORES.NOMBREEMPRESA%TYPE, XNIT IN PROOVEDORES.NIT%TYPE, XURL IN PROOVEDORES.URL%TYPE)
    IS
    BEGIN
        UPDATE PROOVEDORES SET NIT = XNIT
        WHERE PROOVEDORES.NOMBREEMPRESA=XNOMBREEMPRESA ;
        UPDATE PROOVEDORES SET TELEFONO = xtelefono
        WHERE PROOVEDORES.NOMBREEMPRESA=XNOMBREEMPRESA ;
        UPDATE PROOVEDORES SET URL = XURL
        WHERE PROOVEDORES.NOMBREEMPRESA=XNOMBREEMPRESA ;
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002,SQLERRM);
    END;
    PROCEDURE CO_PROOVEDORES(C1 OUT SYS_REFCURSOR) AS
    BEGIN
    OPEN C1 FOR
        SELECT NOMBREEMPRESA,NUMERO,TELEFONO,URL FROM PROOVEDORES;
    END;
    
    PROCEDURE EL_PROOVEDORES(XNUMERO IN PROOVEDORES.NUMERO%TYPE,XTELEFONO IN PROOVEDORES.TELEFONO%TYPE, XNOMBREEMPRESA IN PROOVEDORES.NOMBREEMPRESA%TYPE, XNIT IN PROOVEDORES.NIT%TYPE, XURL IN PROOVEDORES.URL%TYPE)
    IS
    BEGIN
        DELETE FROM PROOVEDORES WHERE XNOMBREEMPRESA = NOMBREEMPRESA;
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20008,SQLERRM);
    END ; 
END;
/
CREATE OR REPLACE PACKAGE BODY CRUD_DESPACHO IS
    PROCEDURE AD_DESPACHO(XFECHAENVIO IN DESPACHOS.FECHAENVIO%TYPE, XFECHAENTREGA IN DESPACHOS.FECHAENTREGA%TYPE)
    IS
    BEGIN 
        INSERT INTO DESPACHOS VALUES (10000,XFECHAENVIO,XFECHAENTREGA);
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20009,SQLERRM);
    END;
    PROCEDURE CO_DESPACHOS (C2 OUT SYS_REFCURSOR) AS
    BEGIN
    OPEN C2 FOR
        SELECT NUMERO,FECHAENVIO,FECHAENTREGA FROM DESPACHOS;
    END;    
END;
/
CREATE OR REPLACE PACKAGE  BODY CRUD_PEDIDO IS
   PROCEDURE AD_PEDIDO(XFECHAORDEN IN PEDIDOS.FECHAORDEN%TYPE, XCANTIDADPRODUCTOS IN PEDIDOS.CANTIDADPRODUCTOS%TYPE, XPAGOREALIZADO IN PEDIDOS.PAGOREALIZADO%TYPE,XPRECIOVENTA IN NUMBER, XPROOVEDOR IN PEDIDOS.PROOVEDOR%TYPE, XDESPACHO IN PEDIDOS.DESPACHO%TYPE)
    IS 
    BEGIN
        INSERT INTO PEDIDOS VALUES (100000,XFECHAORDEN,XCANTIDADPRODUCTOS,XPAGOREALIZADO,XPRECIOVENTA,XPROOVEDOR,XDESPACHO);
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004,SQLERRM);
    END;
    PROCEDURE CO_PEDIDOS (C3 OUT SYS_REFCURSOR) AS
    BEGIN
    OPEN C3 FOR
        SELECT NUMERO,FECHAORDEN,CANTIDADPRODUCTOS,PAGOREALIZADO,PRECIOVENTA,PROOVEDOR,DESPACHO FROM PEDIDOS;
    END;
END;
