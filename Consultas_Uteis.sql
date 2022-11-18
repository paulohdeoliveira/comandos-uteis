
-- Consultar banco de dados
select * from sys.databases

-- Selecionar banco de dados
use Escola

-- Consultar tabelas
select * from sys.tables

-- Descrever tabelas
select * from sys.columns where object_id = object_id('alunos')
select * from sys.columns where object_id = object_id('cursos')
select * from sys.columns where object_id = object_id('alunosCursos')

-- Consultar relacionamentos (chave primária, chave estrangeira)
SELECT ForeignKeys.NAME as "ForeignKeyName", 
       PrimaryKeyTable.NAME as "PrimaryTableName", 
       PrimaryKeyColumn.NAME as "PrimaryColumnName", 
       ForeignKeyTable.NAME as "ReferenceTableName", 
       ForeignKeyColumn.NAME as "ReferenceColumnName", 
       ForeignKeys.update_referential_action_desc as "UpdateAction", 
       ForeignKeys.delete_referential_action_desc as "DeleteAction" 
FROM   sys.foreign_keys ForeignKeys 
       JOIN sys.foreign_key_columns ForeignKeyRelationships 
         ON ( ForeignKeys.object_id = 
              ForeignKeyRelationships.constraint_object_id ) 
       JOIN sys.tables ForeignKeyTable 
         ON ForeignKeyRelationships.parent_object_id = ForeignKeyTable.object_id 
       JOIN sys.columns ForeignKeyColumn 
         ON ( ForeignKeyTable.object_id = ForeignKeyColumn.object_id 
              AND ForeignKeyRelationships.parent_column_id = 
            ForeignKeyColumn.column_id ) 
       JOIN sys.tables PrimaryKeyTable 
         ON ForeignKeyRelationships.referenced_object_id = 
            PrimaryKeyTable.object_id 
       JOIN sys.columns PrimaryKeyColumn 
         ON ( PrimaryKeyTable.object_id = PrimaryKeyColumn.object_id 
              AND ForeignKeyRelationships.referenced_column_id = 
                  PrimaryKeyColumn.column_id ) 
ORDER BY ForeignKeys.NAME

-- Deletar registros

select * from alunos

-- Não é possível deletar devido a "Constraint" - Precisa deletar a FK primeiro e depois deletar a PK.
begin tran
delete from alunos
	output deleted.idAluno as "ID", deleted.nome as "nome excluido", deleted.sobrenome as "sobrenome excluido"
where idAluno=1;

rollback -- ou
commit

-- Deletar a FK.
begin tran
delete from alunosCursos
	output deleted.idAluno as "id alunos", deleted.idCurso as "id curso"
where idAluno=1;

rollback -- ou
commit

-- Atualizar registros

select * from alunos

begin tran
update alunos
set nome = 'Tessa', sobrenome = 'Silva'
	output deleted.nome as "nome excluido", inserted.nome as "nome atualizado", +
		deleted.sobrenome as "sobrenome excluido", inserted.sobrenome as "sobrenome atualizado"
where idAluno=1

rollback -- ou
commit
