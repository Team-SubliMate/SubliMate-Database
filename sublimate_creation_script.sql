DROP TABLE IF EXISTS Items;

CREATE TABLE Items (
    ShelfId INT NOT NULL CHECK (ShelfId>=1),
	ItemId INT NOT NULL CHECK (ItemId>=1),
	Weight FLOAT NOT NULL,
    Product VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    Entry DATE NOT NULL,
	BestBefore DATE,
    RemovedAt TIMESTAMP,
    CONSTRAINT PK_Items PRIMARY KEY (ShelfId, ItemId)
);

CREATE INDEX Shelf_Index ON Items (ShelfId);
    
CREATE OR REPLACE FUNCTION GetNextItemId(IN shelf INT) RETURNS INT AS $$
	declare
		ret INT;
	BEGIN
		IF (SELECT COUNT(*) FROM Items WHERE ShelfId = shelf) = 0 THEN
			RETURN -1;
        ELSE
			SELECT (MAX(ItemId) + 1) INTO ret FROM Items WHERE ShelfId = shelf;
			IF ret IS NULL THEN RETURN 1;
			END IF;
		END IF;
		RETURN ret;
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetNextItemId(0);


INSERT INTO Items (ShelfId, ItemId, Product, Weight, Quantity, Entry)
	Values (1, 1, 'Test', 150, 2, current_date);


SELECT * FROM GetNextItemId(1);