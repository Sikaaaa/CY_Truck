# Définir le compilateur utilisé
CC = gcc
# Définir l'emplacement de l'exécutable
BUILD_DIR = .
# Définir le nom de l'exécutable
EXEC_NAME = CY_Truck

# Compile tout
all: 
	# compile les fichiers .c en objet 
	$(CC) $(BUILD_DIR)/Fonction_t.c -o $(BUILD_DIR)/$(EXEC_NAME)_t1
	$(CC) $(BUILD_DIR)/Tri_nom.c -o $(BUILD_DIR)/$(EXEC_NAME)_t2
	$(CC) $(BUILD_DIR)/Fonction_s.c -o $(BUILD_DIR)/$(EXEC_NAME)_s
	
# Compile les scripts pour l'option t
CY_Truck_t:
	$(CC) $(BUILD_DIR)/Fonction_t.c -o $(BUILD_DIR)/$(EXEC_NAME)_t1
	$(CC) $(BUILD_DIR)/Tri_nom.c -o $(BUILD_DIR)/$(EXEC_NAME)_t2

# Compile le script pour l'option s
CY_Truck_s:
	$(CC) $(BUILD_DIR)/Fonction_s.c -o $(BUILD_DIR)/$(EXEC_NAME)_s

# Efface les fichiers compilés
clean:
	# linux os ci dessous #
	rm -f $(BUILD_DIR)/$(EXEC_NAME)_* 
