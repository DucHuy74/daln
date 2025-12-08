package com.xxxx.ddd.infrastructure.persistence.repository;

import com.xxxx.ddd.domain.model.entity.InvalidatedToken;
import com.xxxx.ddd.domain.repository.InvalidatedTokenRepository;
import com.xxxx.ddd.infrastructure.persistence.mapper.InvalidatedTokenJPAMapper;
import java.util.List;
import java.util.function.Function;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.query.FluentQuery.FetchableFluentQuery;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Repository
@AllArgsConstructor
public class InvalidatedTokenInfrasRepositoryImpl implements InvalidatedTokenRepository {

    InvalidatedTokenJPAMapper invalidatedTokenJPAMapper;

    @Override
    public Optional<InvalidatedToken> findById(String id) {
        return invalidatedTokenJPAMapper.findById(id);
    }

    @Override
    public boolean existsById(String s) {
        return false;
    }

    @Override
    public void flush() {

    }

    @Override
    public <S extends InvalidatedToken> S saveAndFlush(S entity) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> List<S> saveAllAndFlush(Iterable<S> entities) {
        return null;
    }

    @Override
    public void deleteAllInBatch(Iterable<InvalidatedToken> entities) {

    }

    @Override
    public void deleteAllByIdInBatch(Iterable<String> strings) {

    }

    @Override
    public void deleteAllInBatch() {

    }

    @Override
    public InvalidatedToken getOne(String s) {
        return null;
    }

    @Override
    public InvalidatedToken getById(String s) {
        return null;
    }

    @Override
    public InvalidatedToken getReferenceById(String s) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> Optional<S> findOne(Example<S> example) {
        return Optional.empty();
    }

    @Override
    public <S extends InvalidatedToken> List<S> findAll(Example<S> example) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> List<S> findAll(Example<S> example, Sort sort) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> Page<S> findAll(Example<S> example, Pageable pageable) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> long count(Example<S> example) {
        return 0;
    }

    @Override
    public <S extends InvalidatedToken> boolean exists(Example<S> example) {
        return false;
    }

    @Override
    public <S extends InvalidatedToken, R> R findBy(Example<S> example,
                                                    Function<FetchableFluentQuery<S>, R> queryFunction) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> S save(S entity) {
        return null;
    }

    @Override
    public <S extends InvalidatedToken> List<S> saveAll(Iterable<S> entities) {
        return null;
    }

    @Override
    public List<InvalidatedToken> findAll() {
        return null;
    }

    @Override
    public List<InvalidatedToken> findAllById(Iterable<String> strings) {
        return null;
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public void deleteById(String s) {

    }

    @Override
    public void delete(InvalidatedToken entity) {

    }

    @Override
    public void deleteAllById(Iterable<? extends String> strings) {

    }

    @Override
    public void deleteAll(Iterable<? extends InvalidatedToken> entities) {

    }

    @Override
    public void deleteAll() {

    }

    @Override
    public List<InvalidatedToken> findAll(Sort sort) {
        return null;
    }

    @Override
    public Page<InvalidatedToken> findAll(Pageable pageable) {
        return null;
    }
}
