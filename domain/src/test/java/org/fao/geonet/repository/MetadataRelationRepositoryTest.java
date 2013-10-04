package org.fao.geonet.repository;


import static org.fao.geonet.repository.MetadataRepositoryTest.newMetadata;

import org.fao.geonet.domain.Metadata;
import org.fao.geonet.domain.MetadataRelation;
import org.fao.geonet.domain.MetadataRelationId;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.Assert.assertEquals;

@Transactional
public class MetadataRelationRepositoryTest extends AbstractSpringDataTest {

    @Autowired
    MetadataRelationRepository _repo;
    @Autowired
    MetadataRepository _metadataRepo;

    AtomicInteger _inc = new AtomicInteger();
    @Test
    public void testFindOne() {
        MetadataRelation relation = newMetadataRelation();
        relation = _repo.save(relation);

        MetadataRelation relation1 = newMetadataRelation();
        relation1 = _repo.save(relation1);

        assertEquals(relation1, _repo.findOne(relation1.getId()));
        assertEquals(relation, _repo.findOne(relation.getId()));
    }
    @Test
    public void testFindAllById_MetadataId() {
        MetadataRelation relation = newMetadataRelation();
        relation = _repo.save(relation);

        MetadataRelation relation1 = newMetadataRelation();
        _repo.save(relation1);

        final List<MetadataRelation> found = _repo.findAllById_MetadataId(relation.getId().getMetadataId());

        assertEquals(1, found.size());
        assertEquals(relation, found.get(0));
    }

    private MetadataRelation newMetadataRelation() {
        Metadata metadata1 = _metadataRepo.save(newMetadata(_inc));
        Metadata metadata2 = _metadataRepo.save(newMetadata(_inc));

        MetadataRelation relation = new MetadataRelation();
        relation.setId(new MetadataRelationId(metadata1.getId(), metadata2.getId()));

        return relation;
    }

}