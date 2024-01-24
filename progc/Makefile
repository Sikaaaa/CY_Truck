# defines the compiler used
CC = gcc
# defines the build directory
BUILD_DIR = .
# defines the executable name
EXEC_NAME = CY_Truck

# compile tout
all: 
	# compile les fichiers .c en objet 
	$(CC) $(BUILD_DIR)/Fonction_t.c -o $(BUILD_DIR)/$(EXEC_NAME)_t1
	$(CC) $(BUILD_DIR)/Tri_nom.c -o $(BUILD_DIR)/$(EXEC_NAME)_t2
	$(CC) $(BUILD_DIR)/Fonction_s.c -o $(BUILD_DIR)/$(EXEC_NAME)_s
	

CY_Truck_t:
	$(CC) $(BUILD_DIR)/Fonction_t.c -o $(BUILD_DIR)/$(EXEC_NAME)_t1
	$(CC) $(BUILD_DIR)/Tri_nom.c -o $(BUILD_DIR)/$(EXEC_NAME)_t2

CY_Truck_s:
	$(CC) $(BUILD_DIR)/Fonction_s.c -o $(BUILD_DIR)/$(EXEC_NAME)_s

# efface les fichiers compilés
clean:
	# linux os ci dessous #
	rm -f $(BUILD_DIR)/$(EXEC_NAME)_* 
