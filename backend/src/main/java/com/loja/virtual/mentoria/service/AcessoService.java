package com.loja.virtual.mentoria.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.loja.virtual.mentoria.model.Acesso;
import com.loja.virtual.mentoria.repository.AcessoRepository;

@Service
public class AcessoService {
	
	@Autowired
	private AcessoRepository acessoRepository;
	
	public Acesso save(Acesso acesso) {
	/*Qualquer tipo validação*/
		
		 return acessoRepository.save(acesso);
	}

}
