-- Удаление всех записей, которые не связанны с Вологодской областью
--delete FROM culture_data.culture_data_clubs  
--WHERE "data.general.address.fullAddress" NOT LIKE 'обл Вологодская%';


-- Запрос для установки расширения postgis
--CREATE extension postgis;


-- Добавление колонны geom
--ALTER TABLE culture_data.culture_data_clubs  
--ADD COLUMN geom geometry(Point, 4326);


--Преобразовываем данные из таблицы  "data.general.address.mapPosition" в геометрию типа point, 
--после записываем в новую колонку geom
--UPDATE culture_data.culture_data_clubs cdc 
--SET 
--    geom = ST_GeomFromGeoJSON(cdc."data.general.address.mapPosition" )
--WHERE 
--    cdc."data.general.address.mapPosition" IS NOT NULL 


-- Создание таблицы tags
--CREATE TABLE culture_data.tags (
--    tag_id SERIAL PRIMARY KEY,           
--    tag_name VARCHAR(255) NOT NULL,      
--    tag_description TEXT,                
--    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
--    UNIQUE(tag_name)                     
--);

--Заполнение таблицы tags
--INSERT INTO culture_data.tags (tag_name)
--SELECT DISTINCT 
--    jsonb_array_elements_text("data.general.tags") as tag_name
--FROM culture_data.culture_palaces_clubs
--WHERE "data.general.tags" IS NOT NULL 
--  AND jsonb_array_length("data.general.tags") > 0;

-- Проверка добавленных тегов
--SELECT * FROM culture_data.tags ORDER BY tag_name;

-- Создание промежуточной таблицы для связи многие-ко-многим 
--CREATE TABLE culture_data.m2m_culture_palaces_clubs_tags (
--    id SERIAL PRIMARY KEY,
--    culture_palace_id INTEGER NOT NULL REFERENCES culture_data.culture_palaces_clubs(culture_palace_id) ON DELETE CASCADE,
--    tag_id INTEGER NOT NULL REFERENCES culture_data.tags(tag_id) ON DELETE CASCADE,
--    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--    UNIQUE(culture_palace_id, tag_id)  
--);

--Заполнение промежуточной таблицы связями
--INSERT INTO culture_data.m2m_culture_palaces_clubs_tags (culture_palace_id, tag_id)
--SELECT DISTINCT 
--    cpc.culture_palace_id,
--    t.tag_id as tag_id
--FROM culture_data.culture_palaces_clubs cpc
--CROSS JOIN LATERAL jsonb_array_elements_text(cpc."data.general.tags") as tag_value
--JOIN culture_data.tags t ON t.tag_name = tag_value
--WHERE cpc."data.general.tags" IS NOT NULL 
--  AND jsonb_array_length(cpc."data.general.tags") > 0;

-- Создание индексов для оптимизации запросов
--CREATE INDEX idx_m2m_culture_palace_id 
--ON culture_data.m2m_culture_palaces_clubs_tags(culture_palace_id);

--CREATE INDEX idx_m2m_tag_id 
--ON culture_data.m2m_culture_palaces_clubs_tags(tag_id);

-- Составной индекс для часто используемых запросов
--CREATE INDEX idx_m2m_palace_tag 
--ON culture_data.m2m_culture_palaces_clubs_tags(culture_palace_id, tag_id);















