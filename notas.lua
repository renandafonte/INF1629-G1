-- Título: notas.lua
-- Autor: Renan da Fonte
-- Data de criação: 08/04/2017
-- Data de modificação: 08/04/2017
-- Versão: 0.1
-- Tamanho: 75 linhas

	-- Função principal, que coordena a execução do programa
	-- Pré-condição: o programa foi inicializado
	-- Pós-condição: o programa terminou sua execução
	function main()
		print("Calculadora de media de disciplina")
		dadosDisciplina = leDados()
		media = calculaNota(dadosDisciplina)
		imprimeMedia(media)
	end
	
	-- Função que cria 'dadosDisciplina' e lê do input as informações da disciplina cuja média será calculada
	-- Pré-condição: não há
	-- Pós-condição: dados necessários para calcular a média de acordo com o critério apontado estão presentes
	function leDados()
		dadosDisciplina = {}
		
		-- Leitura do critério
		print("Informe o criterio da disciplina:")
		dadosDisciplina["criterio"] = io.read("*n")
		
		-- Leitura das notas para o cálculo da média (segundo http://www.ccpe.ctc.puc-rio.br/wp-content/uploads/2013/01/Resumo-dos-Crit%C3%A9rios-de-Avalia%C3%A7%C3%A3o.doc)
				
		-- Criterio 10 (possui nota teórica e nota para laboratório)
		if dadosDisciplina["criterio"] == 10 then
			print("\nSobre a parte teorica da disciplina:")
			dadosDisciplina["parteTeorica"] = leDados()
			print("\nSobre a parte de laboratorio da disciplina:")
			dadosDisciplina["parteLaboratorio"] = leDados()
			return dadosDisciplina -- o cálculo do critério 10 é efetuado de forma diferente dos demais
		end
		
		-- Leitura da G1
		print("Informe a nota da G1:")
		dadosDisciplina["notaG1"] = io.read("*n")
		
		-- Leitura da G2
		print("Informe a nota da G2:")
		dadosDisciplina["notaG2"] = io.read("*n")
		
		-- Leitura da G3 (caso o critério possua G3)
		if dadosDisciplina["criterio"] >= 4 then -- critérios de 4 a 9 possuem G3		
			print("Informe a nota da G3:")
			dadosDisciplina["notaG3"] = io.read("*n")
		end
		
		-- Leitura da G4 (categorias 4 e 5)
		if (dadosDisciplina["criterio"] == 4) or (dadosDisciplina["criterio"] == 5) then
			print("Informe a nota da G4:")
			dadosDisciplina["notaG4"] = io.read("*n")
		end
		
		-- Leitura da nota de projeto (categoria 9 apenas)
		if dadosDisciplina["criterio"] == 9 then
			print("Informe a nota do projeto:")
			dadosDisciplina["notaProjeto"] = io.read("*n")
		end
		
		return dadosDisciplina
	end
	
	function calculaNota(dadosDisciplina)
		return media
	end
	
	function imprimeMedia(media)
	end

main()