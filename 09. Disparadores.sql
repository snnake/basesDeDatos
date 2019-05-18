--------------------------------------DISPARADORES-------------------------------------------------------------------------------
--Tauret 
CREATE OR REPLACE TRIGGER TG_NIT
BEFORE UPDATE OF NIT ON tauret 
FOR EACH ROW 
BEGIN 
    RAISE_APPLICATION_ERROR(-20001,'No se puede modificar');
END;
/

--Categoriaproducto 
--FK_IDPRODUCTO_CP ON DELETE CASCADE;


--Orden compra 
CREATE OR REPLACE TRIGGER  TG_FECHA
BEFORE INSERT ON ordenCompra
FOR EACH ROW
DECLARE
    XNUMERO NUMBER;
BEGIN
    SELECT MAX(idOrdenCompra)+1 INTO XNUMERO FROM ordenCompra;
    IF XNUMERO IS NULL THEN
        :new.IDORDENCOMPRA := 1;
        :NEW.FECHACOMPRA := sysdate;
        :NEW.TOTAL :=0;
    ELSE
        :new.IDORDENCOMPRA := XNUMERO;
        :NEW.FECHACOMPRA := sysdate;
        :NEW.TOTAL :=0;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_ESTADO_OC
BEFORE UPDATE ON ordenCompra
FOR EACH ROW 
DECLARE 
    temp NUMBER(1);
BEGIN 
    SELECT estado INTO temp FROM ordenCompra WHERE idOrdenCompra = :NEW.idOrdenCompra;
    IF (temp = 1) THEN RAISE_APPLICATION_ERROR(-20003,'No se puede modificar estado');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_TOTAL_ORDENCOMP
BEFORE UPDATE ON ordenCompra
FOR EACH ROW 
DECLARE 
    temp INTEGER;
BEGIN 
    SELECT SUM(detalleCompra.precio) INTO temp
    FROM ordenCompra JOIN detalleCompra ON detalleCompra.idOrdenCompra = ordenCompra.idOrdenCompra
    WHERE ordenCompra.idOrdenCompra = :NEW.idOrdenCompra
    GROUP BY ordenCompra.idOrdenCompra;
    :NEW.TOTAL := (temp);
END;
/

CREATE OR REPLACE TRIGGER TG_ELI_ORDENCOMPRA
BEFORE DELETE ON ordenCompra 
FOR EACH ROW 
DECLARE 
    temp NUMBER(1);
    tempp DATE;
BEGIN
    SELECT ESTADO, fechacompra INTO temp, tempp FROM ordenCompra WHERE idOrdenCompra = :NEW.idOrdenCompra;
    IF (temp=0) OR (ADD_MONTHS(84,tempp) > sysdate) THEN RAISE_APPLICATION_ERROR(-20002,'No se puede eliminar orden de compra');
    END IF;
END;
/

--proveedor 
CREATE OR REPLACE TRIGGER AD_proveedor_id
BEFORE INSERT ON proveedor
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(codigoProveedor)+1) INTO consec FROM proveedor;
    IF consec IS NULL THEN
        :new.codigoProveedor := 1;
    ELSE
        :new.codigoProveedor := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_ELI_PROVEEDOR
BEFORE DELETE ON proveedor 
FOR EACH ROW 
DECLARE 
    temp DATE;
BEGIN
    SELECT FECHA INTO temp FROM ULTICOMPRAPRO WHERE CODIGOPROVEEDOR = :NEW.CODIGOPROVEEDOR;
    IF ADD_MONTHS(84,temp)>sysdate then RAISE_APPLICATION_ERROR(-20002,'Debe pasar un ayo de la ultima compra al proveedor');
    END IF;
END;
/

--Empleado

CREATE OR REPLACE TRIGGER TR_AUTO_IDEMPLEADO
    BEFORE INSERT ON empleado
    FOR EACH ROW
    DECLARE
        VAR4 NUMBER(5);
    BEGIN
        SELECT COUNT(idEmpleado) INTO VAR4 FROM empleado;
    IF :NEW.idEmpleado IS NULL OR :NEW.idEmpleado <> VAR4 THEN
        :NEW.idEmpleado := VAR4 + 1;
    END IF;
END;
/

--entrega 
CREATE OR REPLACE TRIGGER AD_entrega_id
BEFORE INSERT ON entrega
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(identrega)+1) INTO consec FROM entrega;
    IF consec IS NULL THEN
        :new.identrega := 1;
    ELSE
        :new.identrega := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_ESTADO_E
BEFORE UPDATE ON entrega
FOR EACH ROW 
DECLARE 
    temp NUMBER(1);
    tempp DATE;
BEGIN 
    SELECT REALIZACION INTO temp FROM entrega WHERE IDENTREGA = :NEW.IDENTREGA;
    SELECT FECHAENTREGA INTO tempp FROM entrega WHERE IDENTREGA = :NEW.IDENTREGA;
    IF (temp = 1) AND (tempp > sysdate) THEN RAISE_APPLICATION_ERROR(-20003,'No se puede modificar estado');
    ELSIF (temp = 0) AND (tempp < sysdate) THEN RAISE_APPLICATION_ERROR(-20003,'No se puede modificar estado');
    ElSIF (temp = 0) AND (tempp = sysdate) THEN :NEW.REALIZACION := 1;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_FECHA_E
BEFORE INSERT ON entrega
FOR EACH ROW 
BEGIN 
    IF :NEW.FECHASALIDA > :NEW.FECHAENTREGA THEN RAISE_APPLICATION_ERROR(-20002,'Fecha de entrega debe ser mayor o igual al de salida');
    END IF;
END;
/


--cliente
CREATE OR REPLACE TRIGGER AD_cliente_id
BEFORE INSERT ON cliente
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idCliente)+1) INTO consec FROM cliente;
    IF consec IS NULL THEN
        :new.idCliente := 1;
    ELSE
        :new.idCliente := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AD_cliente_nacimiento
BEFORE INSERT ON cliente
FOR EACH ROW
BEGIN 
    IF ADD_MONTHS(216,:NEW.FECHANACIMIENTO) > SYSDATE THEN RAISE_APPLICATION_ERROR(-20003,'El cliente debe ser mayor de 18 años'); 
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_CLIENTE_MOD
BEFORE UPDATE OF FECHANACIMIENTO ON cliente
FOR EACH ROW 
BEGIN 
    RAISE_APPLICATION_ERROR(-20001,'No se puede modificar');
END;
/

CREATE OR REPLACE TRIGGER TG_CLIENTE_MOD_DOC
BEFORE UPDATE OF FECHANACIMIENTO ON cliente
FOR EACH ROW 
BEGIN 
    IF (:old.tipodocumento != :new.tipodocumento) and (:old.numdocumento = :new.numdocumento) 
        THEN RAISE_APPLICATION_ERROR(-20001,'Debe modificar el numero');
    END IF;
END;
/


--producto
CREATE OR REPLACE TRIGGER AD_producto_id
BEFORE INSERT ON producto
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idproducto)+1) INTO consec FROM producto;
    IF consec IS NULL THEN
        :new.idproducto := 1;
    ELSE
        :new.idproducto := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_producto_garantia
BEFORE UPDATE OF GARANTIA ON producto 
FOR EACH ROW 
BEGIN 
    RAISE_APPLICATION_ERROR(-20001,'No se puede modificar garantia');
END;
/

CREATE OR REPLACE TRIGGER TG_ELI_PRODUCTO
BEFORE DELETE ON producto
FOR EACH ROW
DECLARE
    temp DATE;
BEGIN 
    SELECT max(factura.FECHAVENTA) INTO temp 
    FROM LINEAFACTURA JOIN PRODUCTO ON lineaFactura.idProducto = producto.idProducto 
        JOIN factura ON factura.idfactura = lineafactura.idfactura
    WHERE lineaFactura.idProducto = :NEW.idProducto
    GROUP BY lineafactura.idproducto;
    IF ADD_MONTHS(84, temp)> sysdate THEN RAISE_APPLICATION_ERROR(-20002,'No se puede eliminar el producto');
    END IF;
END;
/

--puntoVenta
CREATE OR REPLACE TRIGGER AD_puntoVenta_id
BEFORE INSERT ON puntoVenta
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(NUMERO)+1) INTO consec FROM puntoVenta;
    IF consec IS NULL THEN
        :new.NUMERO := 1;
    ELSE
        :new.NUMERO := consec;
    END IF;
END;
/

--bodega
CREATE OR REPLACE TRIGGER AD_bodega_id
BEFORE INSERT ON bodega
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idbodega)+1) INTO consec FROM bodega;
    IF consec IS NULL THEN
        :new.idbodega := 1;
    ELSE
        :new.idbodega := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_CPACIDAD_B
BEFORE UPDATE ON bodega
FOR EACH ROW 
DECLARE 
    temp INTEGER;
BEGIN 
    SELECT SUM(inventario.cantidadProducto) INTO temp
    FROM inventario JOIN bodega ON bodega.idbodega = inventario.idbodega
    WHERE bodega.idbodega = :NEW.idbodega
    GROUP BY inventario.idbodega;
    IF :NEW.CAPACIDAD < temp THEN RAISE_APPLICATION_ERROR(-20005, 'Capacidad inferior al almacenamiento');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_ELI_BODEGA
BEFORE DELETE ON bodega
FOR EACH ROW 
DECLARE 
    temp INTEGER;
BEGIN 
    SELECT SUM(inventario.cantidadProducto) INTO temp
    FROM inventario JOIN bodega ON bodega.idbodega = inventario.idbodega
    WHERE bodega.idbodega = :NEW.idbodega
    GROUP BY inventario.idbodega;
    IF temp != 0 OR temp!= NULL THEN RAISE_APPLICATION_ERROR(-20005, 'Contiene productos almacenado');
    END IF;
END;
/

--FK_IDBODEGA_JB ON DELETE CASCADE

--detallecompra
CREATE OR REPLACE TRIGGER AD_detalleCompra_id
BEFORE INSERT ON detalleCompra
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(iddetalleCompra)+1) INTO consec FROM detalleCompra;
    IF consec IS NULL THEN
        :new.iddetalleCompra := 1;
    ELSE
        :new.iddetalleCompra := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AD_detalleCompra_precio-------------------------------------------------------------------------------------------------------------------------
BEFORE INSERT ON detalleCompra
FOR EACH ROW
DECLARE 
    TEMP INTEGER;
BEGIN 
    SELECT TOTAL INTO TEMP FROM ordenCompra WHERE :NEW.idOrdenCompra = ordenCompra.idOrdenCompra;
    :NEW.PRECIO := (:new.preciounidad * :new.cantidadproducto);
    --UPDATE ordenCompra SET TOTAL = TEMP+:NEW.PRECIO WHERE :NEW.idOrdenCompra = ordenCompra.idOrdenCompra;
END;
/

--oferta
CREATE OR REPLACE TRIGGER AD_oferta_id
BEFORE INSERT ON oferta
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idoferta)+1) INTO consec FROM oferta;
    IF consec IS NULL THEN
        :new.idoferta := 1;
    ELSE
        :new.idoferta := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_FECHA_O
BEFORE INSERT ON oferta
FOR EACH ROW
BEGIN 
    IF (:NEW.FECHAFIN IS NOT NULL )AND(:NEW.FECHAINICIO > :NEW.FECHAFIN) THEN RAISE_APPLICATION_ERROR(-20003,'La fecha final debe se mayor a la fecha inicial');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_OFERTA_FIN
BEFORE UPDATE ON oferta 
FOR EACH ROW 
DECLARE 
    TEMP NUMBER;
BEGIN 
    SELECT CANTIDADPRODUCTO INTO TEMP FROM PRODUCTOENINVENTARIO WHERE :NEW.IDOFERTA = IDOFERTA;
    IF TEMP > 0 THEN :NEW.FECHAFIN := SYSDATE;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_OFERTA_DELET
BEFORE DELETE ON oferta 
FOR EACH ROW 
DECLARE 
    TEMP DATE;
BEGIN 
    SELECT fechafin INTO TEMP FROM oferta WHERE :NEW.IDOFERTA = IDOFERTA;
    IF ADD_MONTHS(12,temp)>sysdate then RAISE_APPLICATION_ERROR(-20002,'Debe pasar un año del fin de la oferta');
    END IF;
END;
/

--factura 
CREATE OR REPLACE TRIGGER AD_Factura_id
BEFORE INSERT ON Factura 
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idFactura)+1) INTO consec FROM Factura;
    IF consec IS NULL THEN
        :new.idFactura := 1;
        :NEW.TOTAL :=0;
    ELSE
        :new.idFactura := consec;
        :NEW.TOTAL :=0;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TG_TOTAL_F
BEFORE UPDATE ON factura
FOR EACH ROW 
DECLARE 
    temp INTEGER;
BEGIN 
    SELECT SUM(lineaFactura.precio) INTO temp
    FROM factura JOIN lineaFactura ON lineaFactura.idFactura = factura.idFactura
    WHERE factura.idFactura = :NEW.idFactura
    GROUP BY factura.idFactura;
    :NEW.TOTAL := (temp);
END;
/

CREATE OR REPLACE TRIGGER TG_ELI_FACTURA
BEFORE DELETE ON factura
FOR EACH ROW
DECLARE
    temp DATE;
    tempp INTEGER;
    temppp INTEGER;
BEGIN 
    SELECT FECHAVENTA INTO temp FROM FACTURA WHERE idfactura = :NEW.idfactura;
    SELECT COUNT(IDLINEAFACTURA) INTO tempp FROM lineafactura WHERE lineafactura.idfactura = :NEW.idfactura;
    IF ADD_MONTHS(84, temp)> sysdate THEN RAISE_APPLICATION_ERROR(-20002,'No se puede eliminar la factura');
    ELSIF (temp != SYSDATE) OR (tempp != 0) THEN RAISE_APPLICATION_ERROR(-20002,'No se puede eliminar la factura');
    END IF;
END;
/

--Linea factura
CREATE OR REPLACE TRIGGER AD_LineaFactura_id
BEFORE INSERT ON LineaFactura 
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idLineaFactura)+1) INTO consec FROM LineaFactura;
    IF consec IS NULL THEN
        :new.idLineaFactura := 1;
    ELSE
        :new.idLineaFactura := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AD_LineaFactura_precio----------------------------------------------------------------------------------------------------------------------------------
BEFORE INSERT ON LineaFactura
FOR EACH ROW
DECLARE 
    TEMP NUMBER;
    TEMPP INTEGER;
BEGIN 
    SELECT PRECIOUNIDAD INTO TEMP FROM PRODUCTO WHERE :NEW.IDPRODUCTO = PRODUCTO.IDPRODUCTO;
    ---SELECT CANTIDADPRODUCTO INTO TEMPP FROM PRODUCTOENINVENTARIO WHERE PRODUCTOENINVENTARIO.IDPRODUCTO = :NEW.IDPRODUCTO AND ;------------------------------------------------------------------------------------------------------
    :NEW.PRECIO := ( TEMP * :new.cantidadproducto);
    --UPDATE factura SET TOTAL = TOTAL+:NEW.PRECIO WHERE :NEW.idFactura = idFactura;
END;
/

--FK_IDFACTURA_LF ON DELETE CASCADE;

CREATE OR REPLACE TRIGGER TG_ELI_LINEAFACTURA
BEFORE DELETE ON lineaFactura 
FOR EACH ROW 
DECLARE 
    temp DATE;
BEGIN
    SELECT FECHAVENTA INTO temp FROM factura WHERE IDFACTURA = :NEW.IDFACTURA;
    IF temp != sysdate then RAISE_APPLICATION_ERROR(-20002,'No se puede eliminar');
    END IF;
END;
/

--Pago 
CREATE OR REPLACE TRIGGER AD_pago_id
BEFORE INSERT ON Pago 
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(referencia)+1) INTO consec FROM Pago;
    IF consec IS NULL THEN
        :new.referencia := 1;
    ELSE
        :new.referencia := consec;
    END IF;
END;
/



--categoria
CREATE OR REPLACE TRIGGER AD_categoria_id
BEFORE INSERT ON categoria 
FOR EACH ROW
DECLARE
    consec NUMBER;
BEGIN 
    SELECT (MAX(idcategoria)+1) INTO consec FROM categoria;
    IF consec IS NULL THEN
        :new.idcategoria := 1;
    ELSE
        :new.idcategoria := consec;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AD_categoria_descripion
BEFORE INSERT ON categoria 
FOR EACH ROW
BEGIN 
    IF NOT :NEW.NOMBRE NOT IN (:NEW.DESCRIPCION) then RAISE_APPLICATION_ERROR(-20004,'Detalle de categoria no valido');
    END IF;
END;
/

--inventario
--CREATE OR REPLACE TRIGGER TG_SUMCANTIDADES_I
--BEFORE INSERT ON inventario 
--FOR EACH ROW 
--BEGIN 
 --   IF EXIT (:new.idproducto and :new.idbodega)  THEN 
 ----       :NEW.cantidadProducto := old.cantidadProducto + :NEW.cantidadProducto ;
  --  END IF;
--END;
--/
--DROP TRIGGER TG_SUMCANTIDADES_I;

--FK_IDPRODUCTO_I ON DELETE CASCADE 
--FK_IDBODEGA_I ON DELETE CASCADE 


