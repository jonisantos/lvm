ALTER TABLE avaliacao_produto add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE vd_cp_loja_virt add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE status_rastreio add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE produto add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);


ALTER TABLE pessoa_juridica add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);


ALTER TABLE pessoa_fisica add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE nota_item_produto add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE nota_fiscal_venda add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE nota_fiscal_compra add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE marca_produto add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE item_venda_loja add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE imagem_produto add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE forma_pagamento add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE endereco add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE cup_desc add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE conta_receber add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE conta_pagar add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);

ALTER TABLE categoria_produto add CONSTRAINT empresa_fk foreign key(empresa_id)
REFERENCES pessoa_juridica (id);




