import secrets

class FiservDH:
    def init(self, p_hex, g=5):
        self.p = int(p_hex, 16)
        self.g = g
        # Generación segura de llave privada
        self.private_key = secrets.randbelow(self.p - 2) + 2
        # Imprime la llave privada en formato 256 hex
        print(f"DH_PRIVATE_256HEX = {self.private_key:0256X}")

    def get_public_key_hex(self):
        public_key = pow(self.g, self.private_key, self.p)
        # Retorna la llave pública en formato 256 hex
        return f"{public_key:0256X}"

    def compute_shared_secret(self, remote_public_key_hex):
        remote_pk = int(remote_public_key_hex, 16)
        return pow(remote_pk, self.private_key, self.p)


    def validar_llaves(self):
        # 1. Re-calcular la pública para validar la relación matemática
        publica_calculada = pow(self.g, self.private_key, self.p)
        publica_actual = int(self.get_public_key_hex(), 16)
        
        # 2. Verificar que la pública no sea un valor trivial (seguridad básica)
        if publica_actual <= 1 or publica_actual >= self.p - 1:
            return False, "Llave pública fuera de rango seguro."

        # 3. Comparación de integridad
        if publica_calculada == publica_actual:
            return True, "Validación exitosa: La llave pública corresponde a la privada."
        else:
            return False, "Error: La llave pública no coincide con la privada."     
# Uso
p_hex = "E516E43E5457B2F66F6CA367B335EAD8391939FA4DF6C1B7F86E73E9289B464F255790642599981D38D720629663117F79DE8679811681043B90DBE6004351606C55D45FABE03F39E2923BA926A9CD75D4BDBCAB79E78B62A9B847A781C692C063EAACB43A396F01D121D042755D0B7C0B2DFA8B498A57E4D90C30CA049A7AC2B7F73"
dh = FiservDH(p_hex)
print(f"DHPUB_256HEX      = {dh.get_public_key_hex()}")

#dh = FiservDH(p_hex)
es_valido, mensaje = dh.validar_llaves()
print(f"Estado: {es_valido}, Detalle: {mensaje}")
