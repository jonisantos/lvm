package com.loja.virtual.mentoria;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.loja.virtual.mentoria.controller.AcessoController;
import com.loja.virtual.mentoria.model.Acesso;

@SpringBootTest(classes = Application.class)
class ApplicationTests {

	@Autowired
	private AcessoController acessoController;
	
	
	@Test
	public void testCadastroAcesso() {
		
		Acesso acesso = new Acesso();
		
		acesso.setDescricao("ROLE_ADMIN");
		
		acessoController.salvarAcesso(acesso);
	}

}
