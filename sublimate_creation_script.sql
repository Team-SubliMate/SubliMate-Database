USE sublimate;

DROP TABLE IF EXISTS Items;

CREATE TABLE Items (
	FridgeId INT NOT NULL CHECK (FridgeId>=1),
    ShelfId INT NOT NULL CHECK (ShelfId>=1),
	ItemId INT NOT NULL CHECK (ItemId>=1),
	Weight FLOAT NOT NULL,
    Product VARCHAR(255) NOT NULL,
    Entry DATE NOT NULL,
	BestBefore DATE,
    Quantity INT NOT NULL,
    CONSTRAINT PK_Items PRIMARY KEY (FridgeId, ShelfId, ItemId)
);

CREATE INDEX Item_Fridge ON Items (FridgeId);
CREATE INDEX Shelf_Fridge ON Items (FridgeId, ShelfId);

DROP PROCEDURE IF EXISTS GetNextFridgeId;
DROP PROCEDURE IF EXISTS GetNextShelfId;
DROP PROCEDURE IF EXISTS GetNextItemId;

delimiter $$
CREATE PROCEDURE GetNextFridgeId (OUT id INT)
	BEGIN
		SELECT (MAX(FridgeId) + 1) INTO id FROM Items;
        IF id IS NULL THEN SET id=1;
        END IF;
    END$$
    
CREATE PROCEDURE GetNextShelfId (IN fridgeId INT, OUT id INT)
	BEGIN
		IF (SELECT COUNT(*) FROM Items WHERE FridgeId = fridgeId) = 0 THEN
			SELECT -1 INTO id;
        ELSE
			SELECT (MAX(ShelfId) + 1) INTO id FROM Items WHERE FridgeId = fridgeId;
			IF id IS NULL THEN SET id=1;
			END IF;
		END IF;
    END$$
    
CREATE PROCEDURE GetNextItemId(IN fridgeId INT, IN shelfId INT, OUT id INT)
	BEGIN
		IF (SELECT COUNT(*) FROM Items WHERE FridgeId = fridgeId AND ShelfId = shelfId) = 0 THEN
			SELECT -1 INTO id;
        ELSE
			SELECT (MAX(ItemId) + 1) INTO id FROM Items WHERE FridgeId = fridgeId AND ShelfId = shelfId;
			IF id IS NULL THEN SET id=1;
			END IF;
		END IF;
    END$$
delimiter ;

CALL GetNextFridgeId(@0);
CALL GetNextShelfId (0, @b);
CALL GetNextItemId(0, 0, @c);

SELECT @0, @b, @c;

INSERT INTO Items (FridgeId, ShelfId, ItemId, Product, Weight, Quantity, Entry)
	Values (1, 1, 1, "Test", 150, 2, CURDATE());



CALL GetNextFridgeId(@0);
CALL GetNextShelfId (0, @b);
CALL GetNextItemId(0, 0, @c);

SELECT @0, @b, @c;